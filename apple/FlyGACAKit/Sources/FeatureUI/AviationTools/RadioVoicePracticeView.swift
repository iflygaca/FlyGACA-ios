import AVFoundation
import SwiftUI

public struct RadioVoicePracticeView: View {
    @State private var selectedScenario = 0
    @State private var isPushToTalkActive = false
    @State private var recordedTime: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var hasCompletedReadback = false
    @State private var showPhraseologyDebrief = false
    @State private var audioWaveLevel: CGFloat = 0.2

    private let scenarios: [(title: String, airport: String, freq: String, atcTransmission: String, standardReadback: String, keyElements: [String])] = [
        (
            title: "Engine Fire on Takeoff Initial Climb",
            airport: "King Abdulaziz Intl (OEJN)",
            freq: "118.100 MHz (Jeddah Tower)",
            atcTransmission: "Saudia 412, Jeddah Tower, radar contact passing 1,500 feet. Climb to FL 140, turn right heading 280.",
            standardReadback: "MAYDAY MAYDAY MAYDAY, Saudia 412, Engine fire number one, stopping climb at 3,000 feet, turning right heading 280, request immediate return to runway 34 Left.",
            keyElements: ["Mayday 3x distress call", "Aircraft Callsign (Saudia 412)", "Nature of Emergency (Engine Fire)", "Altitude & Heading Intentions", "Immediate Runway Return Request"]
        ),
        (
            title: "Severe Windshear Missed Approach",
            airport: "Abha Regional (OEAB)",
            freq: "124.300 MHz (Abha Tower)",
            atcTransmission: "Flynas 890, wind 180 at 22 gusting 34, runway 17 cleared to land.",
            standardReadback: "Going around, Flynas 890, severe windshear on short final, climbing straight ahead to 9,000 feet on missed approach procedure.",
            keyElements: ["Go-around declaration", "Callsign (Flynas 890)", "Windshear hazard report", "Missed approach climb altitude"]
        ),
        (
            title: "Hydraulic System Loss in Holding Pattern",
            airport: "King Khalid Intl (OERK)",
            freq: "120.000 MHz (Riyadh Radar)",
            atcTransmission: "Gulfstream HZ-MS2, Riyadh Control, hold southwest of SALWA on the 230 radial, maintain FL 120, expect further clearance at time 45.",
            standardReadback: "PAN PAN PAN, PAN PAN PAN, PAN PAN PAN, Riyadh Control, HZ-MS2, hydraulic system pressure loss, flight controls degraded, unable to hold, request direct vector for longest runway with emergency equipment on standby.",
            keyElements: ["Pan-Pan 3x urgency call", "Nature of problem (Hydraulics)", "Unable to comply with hold", "Radar vector & emergency equipment request"]
        ),
        (
            title: "Bird Strike Passing Transition Altitude",
            airport: "King Fahd Intl (OEDF)",
            freq: "119.700 MHz (Dammam Approach)",
            atcTransmission: "Saudi 182, climb FL 180, turn left direct GIDIS.",
            standardReadback: "Saudi 182, multiple bird strike through windshield, request maintain 5,000 feet, turning direct Dammam VOR for precautionary return.",
            keyElements: ["Callsign (Saudi 182)", "Bird strike damage report", "Altitude level-off request", "Precautionary return intention"]
        ),
        (
            title: "IFR Clearance & Pushback on Heavy Traffic",
            airport: "Prince Mohammad Bin Abdulaziz Intl (OEMA)",
            freq: "121.900 MHz (Madinah Delivery)",
            atcTransmission: "Saudia 1024, Madinah Delivery, cleared to Riyadh via GIDIS 1P departure, flight plan route, climb FL 150, squawk 4321.",
            standardReadback: "Cleared to Riyadh, GIDIS 1P departure, flight plan route, climb FL 150, squawk 4321, Saudia 1024.",
            keyElements: ["Destination & SID routing", "Initial cleared flight level (FL 150)", "Assigned transponder code (Squawk 4321)", "Callsign position at end"]
        ),
        (
            title: "VFR Transit Through Class B Control Zone",
            airport: "Riyadh Control Zone (OERK / OETR)",
            freq: "121.500 / 119.000 MHz (Riyadh Approach)",
            atcTransmission: "Cessna HZ-SKY, Riyadh Approach, squawk 5204, maintain VFR at or below 4,500 feet, transit Class Bravo airspace approved direct Diriyah.",
            standardReadback: "Squawk 5204, maintain VFR at or below 4,500 feet, transit approved direct Diriyah, HZ-SKY.",
            keyElements: ["Squawk code (5204)", "VFR altitude ceiling constraint", "Transit routing (direct Diriyah)", "Aircraft registration (HZ-SKY)"]
        ),
        (
            title: "Urgent Medical Evacuation Priority (MEDEVAC)",
            airport: "King Abdulaziz Intl (OEJN)",
            freq: "125.100 MHz (Jeddah Approach)",
            atcTransmission: "Medevac Helicopter 01, Jeddah Approach, radar contact 10 miles northeast, wind 320 at 14, report helipad in sight.",
            standardReadback: "PAN PAN MEDEVAC, Helicopter 01, critical trauma transfer on board, request straight-in approach to King Fahad Hospital helipad, visual contact with landmark.",
            keyElements: ["Urgency Medevac call", "Patient criticality statement", "Direct helipad routing request", "Visual acknowledgment"]
        ),
        (
            title: "Radio Communication Failure (NORDO / Squawk 7600)",
            airport: "Prince Sultan Air Base / Al Kharj (OEKJ)",
            freq: "118.500 MHz (Al Kharj Tower)",
            atcTransmission: "[Radio Silence / No Response from ATC]",
            standardReadback: "Al Kharj Tower, HZ-ABC, Transmitting in the blind, radio receiver failure, squawking 7600, 5 miles south, joining right base runway 31, observing light gun signals.",
            keyElements: ["Transmitting in the blind declaration", "Squawk 7600 notification", "Position & landing intention", "Light gun signals acknowledgment"]
        )
    ]

    public init() {}

    private var current: (title: String, airport: String, freq: String, atcTransmission: String, standardReadback: String, keyElements: [String]) {
        scenarios[selectedScenario]
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Scenario Selector Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<scenarios.count, id: \.self) { idx in
                            Button {
                                selectedScenario = idx
                                hasCompletedReadback = false
                                showPhraseologyDebrief = false
                                HapticFeedback.selection()
                            } label: {
                                Text("Drill \(idx + 1)")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedScenario == idx ? FGTheme.teal : FGTheme.deep)
                                    .foregroundStyle(selectedScenario == idx ? .white : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Radio Frequency & Station Header
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(current.airport)
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(current.title)
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(current.freq)
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(FGTheme.mist)
                                .foregroundStyle(FGTheme.teal)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            Text("ACTIVE VHF")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()
                        .background(FGTheme.mist)

                    // Incoming ATC Radio Transmission
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .foregroundStyle(FGTheme.teal)
                            Text("ATC TRANSMISSION")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.teal)
                            Spacer()
                            Button {
                                playATC(current.atcTransmission)
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "speaker.wave.3.fill")
                                    Text("Play Radio Call")
                                }
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            }
                        }

                        Text(current.atcTransmission)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(FGTheme.mist)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)

                // Push-To-Talk (PTT) Interactive Station
                VStack(spacing: 16) {
                    Text("COCKPIT TRANSMITTER")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(FGTheme.gold)

                    // Live Waveform Visualizer
                    HStack(spacing: 4) {
                        ForEach(0..<18, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isPushToTalkActive ? FGTheme.gold : FGTheme.mist)
                                .frame(
                                    width: 4,
                                    height: isPushToTalkActive ? CGFloat.random(in: 12...50) : 10
                                )
                                .animation(.easeInOut(duration: 0.15).repeatForever().delay(Double(i) * 0.03), value: isPushToTalkActive)
                        }
                    }
                    .frame(height: 55)

                    // Large Native PTT Button
                    Button {
                        // Toggle PTT
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isPushToTalkActive ? FGTheme.clay : FGTheme.teal)
                                .frame(width: 100, height: 100)
                                .shadow(color: (isPushToTalkActive ? FGTheme.clay : FGTheme.teal).opacity(0.6), radius: 14)

                            VStack(spacing: 2) {
                                Image(systemName: "mic.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                Text(isPushToTalkActive ? "ON AIR" : "HOLD PTT")
                                    .font(.system(size: 9, weight: .black, design: .monospaced))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isPushToTalkActive {
                                    isPushToTalkActive = true
                                    HapticFeedback.heavy()
                                    startTimer()
                                }
                            }
                            .onEnded { _ in
                                isPushToTalkActive = false
                                stopTimer()
                                hasCompletedReadback = true
                                showPhraseologyDebrief = true
                                HapticFeedback.success()
                            }
                    )

                    Text(isPushToTalkActive ? String(format: "TRANSMITTING... %.1fs", recordedTime) : "Press and hold PTT button to deliver radio call")
                        .font(.caption)
                        .foregroundStyle(isPushToTalkActive ? FGTheme.clay : .secondary)
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)

                // Phraseology Debrief Card
                if showPhraseologyDebrief {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(FGTheme.sage)
                            Text("ICAO LEVEL 4 PHRASEOLOGY CHECK")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.sage)
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Official Standard Readback:")
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)
                            Text(current.standardReadback)
                                .font(.system(.subheadline, design: .monospaced).bold())
                                .foregroundStyle(FGTheme.gold)
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mandatory Elements Checked:")
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)

                            ForEach(current.keyElements, id: \.self) { elem in
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(FGTheme.sage)
                                    Text(elem)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(FGTheme.deep)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(FGTheme.night)
        .navigationTitle("ATC Voice Simulator")
    }

    private func playATC(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.53
        utterance.pitchMultiplier = 1.05
        speechSynthesizer.speak(utterance)
        HapticFeedback.light()
    }

    private func startTimer() {
        recordedTime = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordedTime += 0.1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
