import CoreModels
import SwiftUI

public struct CockpitHUDView: View {
    @State private var pitch: Double = 0.0 // degrees (-30 to +30)
    @State private var roll: Double = 0.0 // degrees (-60 to +60)
    @State private var airspeed: Double = 110.0 // knots
    @State private var altitude: Double = 3500.0 // feet
    @State private var heading: Double = 340.0 // degrees (0 to 359)
    @State private var vsi: Double = 0.0 // fpm (-2000 to +2000)

    @State private var hudTheme: HUDColorTheme = .glassCockpit
    @State private var isInteractiveDragging = false

    public enum HUDColorTheme: String, CaseIterable, Identifiable {
        case glassCockpit = "Glass Cockpit"
        case tacticalGreen = "Night HUD"
        case amberCockpit = "Amber HUD"

        public var id: String { rawValue }

        var skyColor: Color {
            switch self {
            case .glassCockpit: return Color(red: 0.08, green: 0.35, blue: 0.65)
            case .tacticalGreen: return Color(red: 0.02, green: 0.12, blue: 0.02)
            case .amberCockpit: return Color(red: 0.15, green: 0.08, blue: 0.01)
            }
        }

        var groundColor: Color {
            switch self {
            case .glassCockpit: return Color(red: 0.40, green: 0.25, blue: 0.12)
            case .tacticalGreen: return Color(red: 0.01, green: 0.06, blue: 0.01)
            case .amberCockpit: return Color(red: 0.08, green: 0.04, blue: 0.01)
            }
        }

        var primaryColor: Color {
            switch self {
            case .glassCockpit: return .white
            case .tacticalGreen: return Color(red: 0.2, green: 1.0, blue: 0.3)
            case .amberCockpit: return Color(red: 1.0, green: 0.7, blue: 0.1)
            }
        }

        var accentColor: Color {
            switch self {
            case .glassCockpit: return FGTheme.gold
            case .tacticalGreen: return Color(red: 0.4, green: 1.0, blue: 0.5)
            case .amberCockpit: return Color(red: 1.0, green: 0.85, blue: 0.3)
            }
        }
    }

    public init() {}

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Annunciator Ribbon
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(hudTheme.accentColor)
                            .frame(width: 8, height: 8)
                        Text("GACAR 91")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(hudTheme.accentColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(hudTheme.accentColor.opacity(0.15))
                    .clipShape(Capsule())

                    Spacer()

                    Text("VFR CRUISE · OEJN")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundStyle(hudTheme.primaryColor)

                    Spacer()

                    Picker("HUD Theme", selection: $hudTheme) {
                        ForEach(HUDColorTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(hudTheme.accentColor)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.8))

                // Main PFD Instruments Area
                GeometryReader { geo in
                    ZStack {
                        // Artificial Horizon Layer
                        HorizonView(pitch: pitch, roll: roll, theme: hudTheme, size: geo.size)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        isInteractiveDragging = true
                                        pitch = max(-30, min(30, -Double(value.translation.height) / 4.0))
                                        roll = max(-60, min(60, Double(value.translation.width) / 3.0))
                                        HapticFeedback.selection()
                                    }
                                    .onEnded { _ in
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            pitch = 0.0
                                            roll = 0.0
                                        }
                                        isInteractiveDragging = false
                                        HapticFeedback.light()
                                    }
                            )

                        // Center Aircraft Boresight Reference
                        AircraftSymbol(color: hudTheme.accentColor)

                        // Airspeed Tape (Left)
                        AirspeedTape(speed: airspeed, theme: hudTheme)
                            .frame(width: 65)
                            .position(x: 35, y: geo.size.height / 2)

                        // Altimeter Tape (Right)
                        AltimeterTape(altitude: altitude, vsi: vsi, theme: hudTheme)
                            .frame(width: 75)
                            .position(x: geo.size.width - 40, y: geo.size.height / 2)

                        // Heading Tape (Bottom)
                        HeadingTape(heading: heading, theme: hudTheme)
                            .frame(height: 55)
                            .position(x: geo.size.width / 2, y: geo.size.height - 30)

                        // Drag hint overlay
                        if !isInteractiveDragging {
                            VStack {
                                Spacer()
                                Text("Drag screen to fly attitude indicator")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundStyle(hudTheme.primaryColor.opacity(0.6))
                                    .padding(.bottom, 60)
                            }
                        }
                    }
                }

                // Interactive Flight Deck Sliders Bar
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        SliderRow(label: "SPD", value: $airspeed, range: 40...200, unit: "kts", theme: hudTheme)
                        SliderRow(label: "ALT", value: $altitude, range: 500...15000, step: 100, unit: "ft", theme: hudTheme)
                        SliderRow(label: "HDG", value: $heading, range: 0...359, step: 1, unit: "°", theme: hudTheme)
                    }
                }
                .padding()
                .background(Color(white: 0.08))
            }
        }
        .navigationTitle("Cockpit HUD & PFD")
        .inlineTitleDisplayMode()
    }
}

private struct HorizonView: View {
    let pitch: Double
    let roll: Double
    let theme: CockpitHUDView.HUDColorTheme
    let size: CGSize

    var body: some View {
        ZStack {
            // Sky / Ground Division
            VStack(spacing: 0) {
                Rectangle()
                    .fill(theme.skyColor)
                    .frame(height: size.height * 2)
                Rectangle()
                    .fill(theme.groundColor)
                    .frame(height: size.height * 2)
            }
            .offset(y: CGFloat(pitch) * 6.0)
            .rotationEffect(.degrees(-roll))

            // White Horizon Line
            Rectangle()
                .fill(theme.primaryColor)
                .frame(width: size.width * 2, height: 2)
                .offset(y: CGFloat(pitch) * 6.0)
                .rotationEffect(.degrees(-roll))

            // Pitch Ladder Lines
            PitchLadder(pitch: pitch, roll: roll, theme: theme)
        }
        .clipShape(Rectangle())
    }
}

private struct PitchLadder: View {
    let pitch: Double
    let roll: Double
    let theme: CockpitHUDView.HUDColorTheme

    var body: some View {
        ZStack {
            ForEach([-30, -20, -10, 10, 20, 30], id: \.self) { deg in
                HStack(spacing: 12) {
                    Text("\(abs(deg))")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(theme.primaryColor)
                    Rectangle()
                        .fill(theme.primaryColor)
                        .frame(width: deg > 0 ? 40 : 30, height: 1.5)
                    Spacer()
                    Rectangle()
                        .fill(theme.primaryColor)
                        .frame(width: deg > 0 ? 40 : 30, height: 1.5)
                    Text("\(abs(deg))")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(theme.primaryColor)
                }
                .frame(width: 140)
                .offset(y: CGFloat(-deg) * 6.0 + CGFloat(pitch) * 6.0)
            }
        }
        .rotationEffect(.degrees(-roll))
    }
}

private struct AircraftSymbol: View {
    let color: Color

    var body: some View {
        ZStack {
            // Left wing
            Path { path in
                path.move(to: CGPoint(x: -45, y: 0))
                path.addLine(to: CGPoint(x: -15, y: 0))
                path.addLine(to: CGPoint(x: -15, y: 8))
            }
            .stroke(color, lineWidth: 4)

            // Right wing
            Path { path in
                path.move(to: CGPoint(x: 45, y: 0))
                path.addLine(to: CGPoint(x: 15, y: 0))
                path.addLine(to: CGPoint(x: 15, y: 8))
            }
            .stroke(color, lineWidth: 4)

            // Center dot
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
        }
    }
}

private struct AirspeedTape: View {
    let speed: Double
    let theme: CockpitHUDView.HUDColorTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.75))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(theme.primaryColor.opacity(0.3), lineWidth: 1))

            VStack(spacing: 8) {
                Text(String(format: "%03.0f", speed + 20))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))
                Text(String(format: "%03.0f", speed + 10))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))

                // Current Airspeed Box
                Text(String(format: "%03.0f", speed))
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(theme.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                Text(String(format: "%03.0f", max(0, speed - 10)))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))
                Text(String(format: "%03.0f", max(0, speed - 20)))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))
            }
            .padding(.vertical, 8)
        }
    }
}

private struct AltimeterTape: View {
    let altitude: Double
    let vsi: Double
    let theme: CockpitHUDView.HUDColorTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.75))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(theme.primaryColor.opacity(0.3), lineWidth: 1))

            VStack(spacing: 8) {
                Text(String(format: "%.0f", altitude + 200))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))
                Text(String(format: "%.0f", altitude + 100))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))

                // Current Altitude Box
                Text(String(format: "%.0f", altitude))
                    .font(.system(size: 15, weight: .black, design: .monospaced))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(theme.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                Text(String(format: "%.0f", max(0, altitude - 100)))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))
                Text(String(format: "%.0f", max(0, altitude - 200)))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))
            }
            .padding(.vertical, 8)
        }
    }
}

private struct HeadingTape: View {
    let heading: Double
    let theme: CockpitHUDView.HUDColorTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(theme.primaryColor.opacity(0.3), lineWidth: 1))

            HStack(spacing: 16) {
                Text(headingName(heading - 20))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))

                Text(headingName(heading - 10))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))

                // Current Heading Badge
                VStack(spacing: 2) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(theme.accentColor)
                    Text(String(format: "%03.0f°", heading))
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundStyle(theme.accentColor)
                }

                Text(headingName(heading + 10))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.7))

                Text(headingName(heading + 20))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(theme.primaryColor.opacity(0.5))
            }
            .padding(.horizontal)
        }
    }

    private func headingName(_ deg: Double) -> String {
        let norm = (Int(deg) % 360 + 360) % 360
        switch norm {
        case 0: return "N"
        case 90: return "E"
        case 180: return "S"
        case 270: return "W"
        default: return String(format: "%02d", norm / 10)
        }
    }
}

private struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 1
    let unit: String
    let theme: CockpitHUDView.HUDColorTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(theme.accentColor)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(theme.primaryColor)
            }
            Slider(value: $value, in: range, step: step)
                .tint(theme.accentColor)
                .onChange(of: value) { _, _ in
                    HapticFeedback.light()
                }
        }
    }
}
