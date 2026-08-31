import SwiftUI

public struct DensityAltitudeView: View {
    @State private var elevationStr = "2000"
    @State private var qnhStr = "1013"
    @State private var temperatureStr = "35"
    @State private var isHpa = true

    public init() {}

    private var elevation: Double {
        Double(elevationStr) ?? 0
    }

    private var temperature: Double {
        Double(temperatureStr) ?? 15
    }

    private var pressureAltitude: Double {
        if isHpa {
            let qnh = Double(qnhStr) ?? 1013.25
            return elevation + (1013.25 - qnh) * 27.3
        } else {
            let inHg = Double(qnhStr) ?? 29.92
            return elevation + (29.92 - inHg) * 1000.0
        }
    }

    private var isaTemperature: Double {
        15.0 - (1.98 * (elevation / 1000.0))
    }

    private var isaDeviation: Double {
        temperature - isaTemperature
    }

    private var densityAltitude: Double {
        pressureAltitude + (118.8 * (temperature - isaTemperature))
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Inputs Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Atmospheric Inputs")
                            .font(.headline)
                            .foregroundStyle(FGTheme.gold)
                        Spacer()
                        Picker("Unit", selection: $isHpa) {
                            Text("hPa").tag(true)
                            Text("inHg").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Field Elevation (ft)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Elevation", text: $elevationStr)
                                .numericKeyboard()
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(isHpa ? "QNH (hPa)" : "Altimeter (inHg)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField(isHpa ? "1013" : "29.92", text: $qnhStr)
                                .decimalKeyboard()
                                .padding(10)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Outside Air Temp (OAT °C)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("OAT", text: $temperatureStr)
                            .decimalKeyboard()
                            .padding(10)
                            .background(FGTheme.mist)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Calculated Results
                VStack(spacing: 16) {
                    Text("Calculated Altitudes")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Hero Density Altitude
                    VStack(spacing: 8) {
                        Text("DENSITY ALTITUDE")
                            .font(.caption.bold())
                            .foregroundStyle(FGTheme.gold)
                        Text(String(format: "%.0f ft", densityAltitude))
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(densityAltitude > elevation + 1500 ? FGTheme.clay : FGTheme.teal)
                        Text(String(format: "%+.0f ft vs field elevation", densityAltitude - elevation))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(FGTheme.mist)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pressure Altitude")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f ft", pressureAltitude))
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("ISA Temperature")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.1f °C (%+0.1f)", isaTemperature, isaDeviation))
                                .font(.title3.bold())
                                .foregroundStyle(isaDeviation > 10 ? FGTheme.clay : FGTheme.sage)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if densityAltitude > elevation + 2000 {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(FGTheme.clay)
                            Text("High Density Altitude Warning: Aircraft takeoff distance, rate of climb, and engine performance will be significantly degraded.")
                                .font(.footnote)
                                .foregroundStyle(FGTheme.clay)
                        }
                        .padding()
                        .background(FGTheme.clay.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(FGTheme.night)
        .navigationTitle("Density Altitude")
    }
}
