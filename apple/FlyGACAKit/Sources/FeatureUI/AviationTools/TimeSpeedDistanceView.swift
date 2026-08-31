import SwiftUI

public struct TimeSpeedDistanceView: View {
    @State private var trueAirspeedStr = "120"
    @State private var courseStr = "090"
    @State private var distanceStr = "150"
    @State private var windDirStr = "040"
    @State private var windSpeedStr = "15"

    public init() {}

    private var tas: Double { max(1, Double(trueAirspeedStr) ?? 100) }
    private var course: Double { Double(courseStr) ?? 0 }
    private var distance: Double { Double(distanceStr) ?? 0 }
    private var windDir: Double { Double(windDirStr) ?? 0 }
    private var windSpeed: Double { Double(windSpeedStr) ?? 0 }

    // Wind triangle calculations
    private var windAngleRad: Double {
        let diff = (windDir - course) * .pi / 180.0
        return diff
    }

    private var crosswindComponent: Double {
        windSpeed * sin(windAngleRad)
    }

    private var headwindComponent: Double {
        windSpeed * cos(windAngleRad)
    }

    private var windCorrectionAngleDeg: Double {
        let ratio = max(-1.0, min(1.0, crosswindComponent / tas))
        return asin(ratio) * 180.0 / .pi
    }

    private var trueHeadingDeg: Double {
        var hdg = course + windCorrectionAngleDeg
        if hdg < 0 { hdg += 360 }
        if hdg >= 360 { hdg -= 360 }
        return hdg
    }

    private var groundSpeed: Double {
        let wcaRad = windCorrectionAngleDeg * .pi / 180.0
        let gs = (tas * cos(wcaRad)) - headwindComponent
        return max(10, gs)
    }

    private var timeEnrouteHours: Double {
        distance / groundSpeed
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Inputs
                VStack(alignment: .leading, spacing: 16) {
                    Text("Navigation Leg Parameters")
                        .font(.headline)
                        .foregroundStyle(FGTheme.gold)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("True Airspeed (kts)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("120", text: $trueAirspeedStr)
                                .numericKeyboard()
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Desired Course (°)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("090", text: $courseStr)
                                .numericKeyboard()
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Leg Distance (NM)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("150", text: $distanceStr)
                                .numericKeyboard()
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Wind Dir / Spd")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 4) {
                                TextField("040", text: $windDirStr)
                                    .numericKeyboard()
                                    .padding(10)
                                    .background(FGTheme.mist)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundStyle(.white)
                                Text("/")
                                    .foregroundStyle(.secondary)
                                TextField("15", text: $windSpeedStr)
                                    .numericKeyboard()
                                    .padding(10)
                                    .background(FGTheme.mist)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Calculated Results
                VStack(spacing: 16) {
                    Text("Calculated Flight Vector")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("GROUNDSPEED")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(String(format: "%.0f kts", groundSpeed))
                                .font(.title.bold())
                                .foregroundStyle(groundSpeed >= tas ? FGTheme.sage : FGTheme.teal)
                            Text(String(format: "%+.0f kts vs TAS", groundSpeed - tas))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("TRUE HEADING")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(String(format: "%03.0f°", trueHeadingDeg))
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            Text(String(format: "WCA: %+0.1f°", windCorrectionAngleDeg))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ESTIMATED TIME ENROUTE (ETE)")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            let hrs = Int(timeEnrouteHours)
                            let mins = Int((timeEnrouteHours - Double(hrs)) * 60)
                            let secs = Int(((timeEnrouteHours - Double(hrs)) * 60 - Double(mins)) * 60)
                            Text("\(hrs)h \(mins)m \(secs)s")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(FGTheme.night)
        .navigationTitle("Time, Speed & Distance")
    }
}
