import StudyEngines
import SwiftUI

/// One headline number on a results/analytics surface (web `ResultStat`).
public struct ResultStat: View {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2.bold())
                .foregroundStyle(FGTheme.teal)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

/// A single answer option row with reveal states.
struct ChoiceRow: View {
    enum Mark {
        case none
        case selected
        case correct
        case wrong
    }

    /// 0-based option index — rendered as an A/B/C/D badge before the text.
    let index: Int
    let text: String
    let mark: Mark
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Badge
                Text(String(UnicodeScalar(65 + index)!))
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(badgeText)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(badgeFill))
                    .overlay(Circle().strokeBorder(borderColor, lineWidth: 1.5))

                Text(text)
                    .font(.body)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                switch mark {
                case .correct:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(FGTheme.sage)
                case .wrong:
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(FGTheme.clay)
                case .selected:
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundStyle(FGTheme.teal)
                case .none:
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundStyle(FGTheme.mist)
                }
            }
            .padding(14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(cardFill)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: mark == .none ? 1 : 1.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: glowColor.opacity(0.12), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var cardFill: Color {
        switch mark {
        case .correct: FGTheme.sage.opacity(0.12)
        case .wrong: FGTheme.clay.opacity(0.12)
        case .selected: FGTheme.teal.opacity(0.15)
        case .none: FGTheme.deep.opacity(0.85)
        }
    }

    private var borderColor: Color {
        switch mark {
        case .correct: FGTheme.sage
        case .wrong: FGTheme.clay
        case .selected: FGTheme.teal
        case .none: FGTheme.mist
        }
    }

    private var glowColor: Color {
        switch mark {
        case .correct: FGTheme.sage
        case .wrong: FGTheme.clay
        case .selected: FGTheme.teal
        case .none: Color.clear
        }
    }

    private var badgeFill: Color {
        switch mark {
        case .correct: FGTheme.sage.opacity(0.22)
        case .wrong: FGTheme.clay.opacity(0.22)
        case .selected: FGTheme.teal.opacity(0.3)
        case .none: FGTheme.surface
        }
    }

    private var badgeText: Color {
        switch mark {
        case .correct: FGTheme.sage
        case .wrong: FGTheme.clay
        case .selected: .white
        case .none: FGTheme.gold
        }
    }
}

/// End-of-session summary: score, pass/fail when scored, per-bank breakdown.
struct SessionResultView: View {
    let result: SessionResult
    let bankTitles: [String: String]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Score Card
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(result.passed == true ? FGTheme.sage.opacity(0.15) : FGTheme.gold.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: result.passed == true ? "trophy.fill" : "chart.bar.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(result.passed == true ? FGTheme.sage : FGTheme.gold)
                    }

                    Text("\(result.percent)%")
                        .font(.system(size: 48, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)

                    if let passed = result.passed {
                        Text(passed ? Loc.t("result.pass") : Loc.t("result.fail"))
                            .font(.system(size: 12, weight: .black))
                            .textCase(.uppercase)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(passed ? FGTheme.sage : FGTheme.clay)
                            .foregroundStyle(.black)
                            .clipShape(Capsule())
                    }

                    HStack(spacing: 24) {
                        ResultStat(label: Loc.t("result.correct"), value: "\(result.correct)/\(result.total)")
                        ResultStat(label: Loc.t("result.score"), value: "\(result.percent)%")
                    }
                }
                .glassCard(glowColor: result.passed == true ? FGTheme.sage : FGTheme.gold, glowOpacity: 0.15)

                if result.byBank.count > 1 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Loc.t("result.byTopic"))
                            .font(.headline)
                            .foregroundStyle(FGTheme.gold)

                        ForEach(result.byBank.keys.sorted(), id: \.self) { bankID in
                            let score = result.byBank[bankID]!
                            HStack {
                                Text(bankTitles[bankID] ?? bankID)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(score.correct)/\(score.total)")
                                    .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                    .foregroundStyle(FGTheme.teal)
                            }
                            .padding(12)
                            .background(FGTheme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .glassCard(glowColor: FGTheme.teal)
                }

                Disclaimer()
            }
            .padding()
        }
        .cockpitBackground()
    }
}

/// A thin progress bar for a running session — answered fraction fills teal with glowing head.
struct SessionProgressBar: View {
    let answered: Int
    let total: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(FGTheme.mist)
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [FGTheme.teal, FGTheme.cyanGlow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * fraction)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: fraction)
            }
        }
        .frame(height: 6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Loc.t("a11y.progress", answered, total))
    }

    private var fraction: CGFloat {
        total > 0 ? CGFloat(answered) / CGFloat(total) : 0
    }
}

/// One line of a radio exchange ("TOWER: cleared to land …") rendered
/// cockpit-style: speaker label in teal caps, the transmission in a monospaced
/// voice that reads like a CPDLC/transcript block. Used by `ScenarioCard`.
struct TranscriptLine: View {
    let line: String

    var body: some View {
        if let split = Self.split(line) {
            (Text(split.speaker.uppercased() + "  ")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(FGTheme.cyanGlow)
             + Text(split.text)
                .font(.system(.callout, design: .monospaced))
                .foregroundStyle(.white))
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            Text(line)
                .font(.system(.callout, design: .monospaced))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// "TOWER: go around" → ("TOWER", "go around"); a line with no speaker
    /// prefix returns nil and renders as a plain line.
    static func split(_ line: String) -> (speaker: String, text: String)? {
        guard let colon = line.firstIndex(of: ":") else { return nil }
        let speaker = String(line[line.startIndex..<colon])
        let trimmed = speaker.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty,
              trimmed.count <= 12,
              trimmed.allSatisfy({ $0.isUppercase || $0.isNumber || $0 == " " || $0 == "/" }) else { return nil }
        return (trimmed, String(line[colon...].dropFirst()).trimmingCharacters(in: .whitespaces))
    }
}

/// The scenario surface for ELPT-style questions: the radio exchange sits in a
/// bordered card ("RADIO EXCHANGE") visually distinct from the question itself,
/// so a live-transmission scenario reads like the real test, not a wall of text.
struct ScenarioCard: View {
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(Loc.t("quiz.transcript"), systemImage: "dot.radiowaves.left.and.right")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(FGTheme.cyanGlow)
                    .textCase(.uppercase)
                Spacer()
                Text("LIVE CPDLC")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(FGTheme.cyanGlow.opacity(0.15))
                    .foregroundStyle(FGTheme.cyanGlow)
                    .clipShape(Capsule())
            }

            ForEach(lines, id: \.self) { line in
                TranscriptLine(line: line)
            }
        }
        .glassCard(glowColor: FGTheme.cyanGlow, glowOpacity: 0.1, padding: 14)
    }
}

public extension View {
    @ViewBuilder
    func numericKeyboard() -> some View {
        #if os(iOS)
        self.keyboardType(.numberPad)
        #else
        self
        #endif
    }

    @ViewBuilder
    func decimalKeyboard() -> some View {
        #if os(iOS)
        self.keyboardType(.decimalPad)
        #else
        self
        #endif
    }

    @ViewBuilder
    func inlineTitleDisplayMode() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
