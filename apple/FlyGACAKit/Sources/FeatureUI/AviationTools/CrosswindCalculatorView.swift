import SwiftUI

public struct CrosswindCalculatorView: View {
    @State private var runwayHeading: Double = 340 // 34L
    @State private var windDirection: Double = 300
    @State private var windSpeed: Double = 18
    @State private var windGust: Double = 25
    @State private var maxCrosswindLimit: Double = 15

    @State private var isSpinningRunway = false
    @State private var isSpinningWind = false

    public init() {}

    private var runwayNumber: String {
        let num = Int(round(runwayHeading / 10.0))
        let normalized = num == 0 ? 36 : (num > 36 ? num - 36 : num)
        return String(format: "%02d", normalized)
    }

    private var angleDiffRad: Double {
        abs(windDirection - runwayHeading) * .pi / 180.0
    }

    private var headwindComponent: Double {
        windSpeed * cos(angleDiffRad)
    }

    private var crosswindComponent: Double {
        abs(windSpeed * sin(angleDiffRad))
    }

    private var gustCrosswindComponent: Double {
        abs(windGust * sin(angleDiffRad))
    }

    private var isCrosswindExceeded: Bool {
        crosswindComponent > maxCrosswindLimit || gustCrosswindComponent > maxCrosswindLimit
    }

    private var crosswindFromRight: Bool {
        var diff = windDirection - runwayHeading
        while diff < -180 { diff += 360 }
        while diff > 180 { diff -= 360 }
        return diff > 0
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Interactive Tactical Compass Dial
                VStack(spacing: 12) {
                    HStack {
                        Label("TACTICAL COMPASS DIAL", systemImage: "safari.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(FGTheme.gold)
                        Spacer()
                        Text("Touch & drag to rotate")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    ZStack {
                        // Outer Compass Ring
                        Circle()
                            .strokeBorder(FGTheme.mist, lineWidth: 2)
                            .frame(width: 260, height: 260)
                            .background(Circle().fill(FGTheme.deep.opacity(0.8)))

                        // Cardinal Direction Marks
                        ForEach([0, 90, 180, 270], id: \.self) { deg in
                            Text(cardinalName(deg))
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .foregroundStyle(FGTheme.gold.opacity(0.8))
                                .offset(y: -115)
                                .rotationEffect(.degrees(Double(deg)))
                        }

                        // Compass Tick Marks (every 30 deg)
                        ForEach(0..<12, id: \.self) { i in
                            Rectangle()
                                .fill(FGTheme.mist)
                                .frame(width: 1.5, height: 8)
                                .offset(y: -122)
                                .rotationEffect(.degrees(Double(i * 30)))
                        }

                        // Physical Runway Surface (Rotates with runwayHeading)
                        ZStack {
                            // Runway Strip
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(white: 0.22))
                                .frame(width: 32, height: 190)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(Color.white.opacity(0.6), lineWidth: 1.5)
                                )

                            // Centerline Dashes
                            VStack(spacing: 8) {
                                ForEach(0..<6, id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 3, height: 12)
                                }
                            }

                            // Runway Numbers at Thresholds
                            VStack {
                                Text(runwayNumber)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundStyle(FGTheme.gold)
                                    .padding(.top, 8)
                                Spacer()
                                Text(reciprocalNumber)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundStyle(Color.white.opacity(0.8))
                                    .rotationEffect(.degrees(180))
                                    .padding(.bottom, 8)
                            }
                            .frame(height: 190)
                        }
                        .rotationEffect(.degrees(runwayHeading))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let vector = CGVector(dx: value.location.x - 130, dy: value.location.y - 130)
                                    var angle = atan2(vector.dy, vector.dx) * 180.0 / .pi + 90.0
                                    if angle < 0 { angle += 360 }
                                    let snapped = round(angle / 5.0) * 5.0
                                    if Int(snapped) != Int(runwayHeading) {
                                        runwayHeading = snapped
                                        HapticFeedback.selection()
                                    }
                                }
                        )

                        // Wind Vector Arrow (Rotates with windDirection)
                        ZStack {
                            VStack(spacing: 0) {
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundStyle(FGTheme.teal)
                                    .shadow(color: FGTheme.teal.opacity(0.8), radius: 6)
                                Rectangle()
                                    .fill(FGTheme.teal)
                                    .frame(width: 3, height: 60)
                                Spacer()
                            }
                            .frame(height: 240)
                        }
                        .rotationEffect(.degrees(windDirection))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let vector = CGVector(dx: value.location.x - 130, dy: value.location.y - 130)
                                    var angle = atan2(vector.dy, vector.dx) * 180.0 / .pi + 90.0
                                    if angle < 0 { angle += 360 }
                                    let snapped = round(angle / 5.0) * 5.0
                                    if Int(snapped) != Int(windDirection) {
                                        windDirection = snapped
                                        HapticFeedback.selection()
                                    }
                                }
                        )
                    }
                    .frame(width: 260, height: 260)
                    .padding(.vertical, 8)
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)

                // Computed Vector Results
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ResultCard(
                            label: "CROSSWIND COMPONENT",
                            value: String(format: "%.1f KTS", crosswindComponent),
                            subtitle: crosswindFromRight ? "FROM RIGHT" : "FROM LEFT",
                            isWarning: isCrosswindExceeded,
                            accentColor: isCrosswindExceeded ? FGTheme.clay : FGTheme.teal
                        )

                        ResultCard(
                            label: headwindComponent >= 0 ? "HEADWIND" : "TAILWIND",
                            value: String(format: "%.1f KTS", abs(headwindComponent)),
                            subtitle: headwindComponent >= 0 ? "DIRECT ADVANTAGE" : "CHECK PERFORMANCE",
                            isWarning: headwindComponent < 0,
                            accentColor: headwindComponent >= 0 ? FGTheme.sage : FGTheme.clay
                        )
                    }

                    if isCrosswindExceeded {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.white)
                            Text("CROSSWIND EXCEEDS LIMIT (\(Int(maxCrosswindLimit)) KTS)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(FGTheme.clay)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)

                // Interactive Sliders & Quick Controls
                VStack(alignment: .leading, spacing: 14) {
                    Text("Interactive Controls")
                        .font(.headline)
                        .foregroundStyle(FGTheme.gold)

                    // Runway Heading
                    ControlSlider(
                        title: "Runway Heading (RWY \(runwayNumber))",
                        value: $runwayHeading,
                        range: 0...359,
                        step: 5,
                        unit: "°"
                    )

                    // Wind Direction
                    ControlSlider(
                        title: "Wind Direction",
                        value: $windDirection,
                        range: 0...359,
                        step: 5,
                        unit: "°"
                    )

                    // Wind Speed
                    ControlSlider(
                        title: "Wind Speed",
                        value: $windSpeed,
                        range: 0...60,
                        step: 1,
                        unit: "kts"
                    )

                    // Max Demonstrated Limit
                    ControlSlider(
                        title: "Max Crosswind Limit",
                        value: $maxCrosswindLimit,
                        range: 5...35,
                        step: 1,
                        unit: "kts"
                    )
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(FGTheme.night)
        .navigationTitle("Crosswind Visualizer")
    }

    private var reciprocalNumber: String {
        let rec = (Int(runwayHeading) + 180) % 360
        let num = Int(round(Double(rec) / 10.0))
        let normalized = num == 0 ? 36 : (num > 36 ? num - 36 : num)
        return String(format: "%02d", normalized)
    }

    private func cardinalName(_ deg: Int) -> String {
        switch deg {
        case 0: return "N"
        case 90: return "E"
        case 180: return "S"
        case 270: return "W"
        default: return ""
        }
    }
}

private struct ResultCard: View {
    let label: String
    let value: String
    let subtitle: String
    let isWarning: Bool
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 9, weight: .black))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundStyle(accentColor)
            Text(subtitle)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(isWarning ? FGTheme.clay : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(FGTheme.deep)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(accentColor.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct ControlSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.system(.subheadline, design: .monospaced).bold())
                    .foregroundStyle(FGTheme.teal)
            }
            Slider(value: $value, in: range, step: step)
                .tint(FGTheme.teal)
                .onChange(of: value) { _, _ in
                    HapticFeedback.selection()
                }
        }
        .padding(10)
        .background(FGTheme.mist)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
