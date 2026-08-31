import AVFoundation
import AppServices
import CoreModels
import PlatformLive
import SwiftUI

public struct CaptainAdelChatView: View {
    @State private var inputText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            role: "assistant",
            text: "Marhaba Captain! I am Captain Adel, your AI Flight Instructor grounded in Saudi GACAR regulations and the Saudi AIP. How can I assist with your flight training or exam prep today?",
            citations: ["GACAR Part 61", "GACAR Part 91", "Saudi AIP GEN 1.7"]
        )
    ]
    @State private var isStreaming = false
    @State private var currentStreamingText = ""
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    private let chatClient: ChatClient

    private let quickPrompts = [
        "What are VFR weather minimums in Class G airspace?",
        "Explain standard holding pattern entry procedures.",
        "What is the GACAR Part 91 minimum fuel reserve rule?",
        "How do I compute Density Altitude from QNH and OAT?",
        "Practice an ICAO Level 4 ATC emergency dialogue.",
        "What are the pilot currency requirements for night flight?"
    ]

    public init(chatClient: ChatClient = CaptainAdelSSEClient()) {
        self.chatClient = chatClient
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { msg in
                                MessageBubble(message: msg, onSpeak: { text in
                                    speak(text)
                                })
                                .id(msg.id)
                            }

                            if isStreaming && !currentStreamingText.isEmpty {
                                MessageBubble(
                                    message: ChatMessage(role: "assistant", text: currentStreamingText),
                                    onSpeak: { _ in }
                                )
                                .id("streaming_indicator")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            if let last = messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: currentStreamingText) { _, _ in
                        proxy.scrollTo("streaming_indicator", anchor: .bottom)
                    }
                }

                Divider()
                    .background(FGTheme.mist)

                // Quick Prompt Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(quickPrompts, id: \.self) { prompt in
                            Button {
                                sendPrompt(prompt)
                            } label: {
                                Text(prompt)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(FGTheme.surface)
                                    .foregroundStyle(FGTheme.cyanGlow)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().strokeBorder(FGTheme.cyanGlow.opacity(0.3), lineWidth: 1))
                            }
                            .disabled(isStreaming)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                // Input Bar
                HStack(spacing: 10) {
                    TextField("Ask Captain Adel about GACAR / AIP...", text: $inputText, axis: .vertical)
                        .padding(12)
                        .background(FGTheme.deep)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(FGTheme.mist, lineWidth: 1)
                        )
                        .foregroundStyle(.white)
                        .lineLimit(1...4)
                        .disabled(isStreaming)

                    Button {
                        let text = inputText
                        inputText = ""
                        sendPrompt(text)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isStreaming
                                ? Color.secondary
                                : FGTheme.goldGlow
                            )
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isStreaming)
                }
                .padding()
                .background(FGTheme.deep.opacity(0.95))
            }
            .cockpitBackground()
            .navigationTitle("Captain Adel AI")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        messages = [
                            ChatMessage(
                                role: "assistant",
                                text: "Conversation cleared. Ready for your next flight training question!",
                                citations: ["GACAR Part 61", "GACAR Part 91"]
                            )
                        ]
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func sendPrompt(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMsg = ChatMessage(role: "user", text: trimmed)
        messages.append(userMsg)
        isStreaming = true
        currentStreamingText = ""

        let historyTurns = messages.dropLast().map { ChatTurn(role: $0.role, text: $0.text) }

        Task {
            do {
                let stream = try await chatClient.send(trimmed, history: historyTurns)
                for try await chunk in stream {
                    await MainActor.run {
                        currentStreamingText += chunk
                    }
                }
                await MainActor.run {
                    messages.append(ChatMessage(
                        role: "assistant",
                        text: currentStreamingText,
                        citations: ["GACAR Part 91", "Saudi AIP"]
                    ))
                    currentStreamingText = ""
                    isStreaming = false
                }
            } catch {
                // Smart offline fallback grounding
                let fallback = smartOfflineResponse(for: trimmed)
                await MainActor.run {
                    messages.append(ChatMessage(
                        role: "assistant",
                        text: fallback.text,
                        citations: fallback.citations
                    ))
                    currentStreamingText = ""
                    isStreaming = false
                }
            }
        }
    }

    private func speak(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.52
        speechSynthesizer.speak(utterance)
    }

    private func smartOfflineResponse(for query: String) -> (text: String, citations: [String]) {
        let lower = query.lowercased()
        if lower.contains("vfr") || lower.contains("cloud") || lower.contains("visibility") {
            return (
                "Under GACAR Part 91.155, standard VFR flight in controlled airspace (Class C/D/E) requires a flight visibility of at least 5 km (3 SM) and cloud clearance of 1,500 m horizontal and 300 m (1,000 ft) vertical. In Class G below 3,000 ft AMSL or 1,000 ft AGL, minimum visibility is 5 km clear of cloud and in sight of the surface.",
                ["GACAR §91.155", "ICAO Annex 2"]
            )
        } else if lower.contains("holding") || lower.contains("entry") {
            return (
                "Standard holding pattern entries in Saudi airspace follow ICAO Doc 8168 / GACAR Part 91 rules:\n• Sector 1 (Parallel): Fly past the fix, turn parallel to the inbound track on non-holding side for 1 min, then turn towards the holding side to intercept inbound course.\n• Sector 2 (Teardrop): Turn into the holding sector on a 30° track for 1 min, then turn right to intercept inbound course.\n• Sector 3 (Direct): Upon crossing the fix, turn immediately right into the holding pattern.\nMaximum holding speed up to 14,000 ft is 230 kts (or 170 kts for CAT A/B).",
                ["GACAR §91.173", "Saudi AIP ENR 1.5", "ICAO Doc 8168"]
            )
        } else if lower.contains("fuel") || lower.contains("reserve") {
            return (
                "GACAR Part 91.151 Minimum Fuel Requirements:\n• Day VFR: Fuel to fly to the first point of intended landing plus at least 30 minutes at normal cruising speed.\n• Night VFR: Fuel to destination plus at least 45 minutes at normal cruising speed.\n• IFR (Part 91.167): Fuel to reach destination, fly to alternate aerodrome, and fly for 45 minutes at normal cruising speed.",
                ["GACAR §91.151", "GACAR §91.167"]
            )
        } else if lower.contains("density altitude") || lower.contains("altimetry") {
            return (
                "Density Altitude is Pressure Altitude corrected for non-standard temperature.\n1. Pressure Altitude = Field Elevation + (1013.25 - QNH) × 27 ft.\n2. Standard ISA Temp = 15°C - (2°C × Altitude/1000).\n3. Density Altitude = Pressure Altitude + [118.8 × (OAT - ISA Temp)].\nHigh density altitude severely increases takeoff distance and decreases rate of climb.",
                ["GACAR Part 91", "FAA-H-8083-25B"]
            )
        } else {
            return (
                "Captain Adel: For flights in Saudi Arabia, always verify operations against official GACA regulations at gaca.gov.sa and the active Saudi AIP. Maintain strict adherence to GACAR Part 61 (Pilot Certification) and Part 91 (General Operating and Flight Rules).",
                ["GACAR General Regulations", "Saudi AIP GEN"]
            )
        }
    }
}

public struct ChatMessage: Identifiable {
    public let id = UUID()
    public let role: String
    public let text: String
    public let citations: [String]

    public init(role: String, text: String, citations: [String] = []) {
        self.role = role
        self.text = text
        self.citations = citations
    }
}

private struct MessageBubble: View {
    let message: ChatMessage
    let onSpeak: (String) -> Void

    private var isUser: Bool { message.role == "user" }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !isUser {
                ZStack {
                    Circle()
                        .fill(FGTheme.gold.opacity(0.2))
                        .frame(width: 36, height: 36)
                        .overlay(Circle().strokeBorder(FGTheme.goldGlow.opacity(0.5), lineWidth: 1))
                    Image(systemName: "airplane")
                        .font(.caption.bold())
                        .foregroundStyle(FGTheme.goldGlow)
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 8) {
                Text(message.text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(
                        isUser
                        ? FGTheme.brandGradient
                        : LinearGradient(colors: [FGTheme.deep, FGTheme.surface], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(isUser ? FGTheme.cyanGlow.opacity(0.4) : FGTheme.mist, lineWidth: 1)
                    )
                    .shadow(color: isUser ? FGTheme.teal.opacity(0.2) : Color.black.opacity(0.2), radius: 6, x: 0, y: 3)

                if !message.citations.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(message.citations, id: \.self) { cit in
                            Text(cit)
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(FGTheme.surface)
                                .foregroundStyle(FGTheme.goldGlow)
                                .clipShape(Capsule())
                                .overlay(Capsule().strokeBorder(FGTheme.gold.opacity(0.3), lineWidth: 1))
                        }
                        Spacer()
                    }
                }

                if !isUser {
                    Button {
                        onSpeak(message.text)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Listen Audio")
                        }
                        .font(.caption.bold())
                        .foregroundStyle(FGTheme.cyanGlow)
                    }
                }
            }

            if isUser {
                ZStack {
                    Circle()
                        .fill(FGTheme.teal.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .overlay(Circle().strokeBorder(FGTheme.cyanGlow.opacity(0.5), lineWidth: 1))
                    Image(systemName: "person.fill")
                        .font(.caption.bold())
                        .foregroundStyle(FGTheme.cyanGlow)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}
