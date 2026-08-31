import SwiftUI

public struct WeightAndBalanceView: View {
    // Standard training aircraft preset (C172 style)
    @State private var emptyWeightStr = "1500"
    @State private var emptyArmStr = "38.5"

    @State private var pilotWeightStr = "180"
    @State private var frontPassWeightStr = "170"
    @State private var frontArmStr = "37.0"

    @State private var rearPassWeightStr = "150"
    @State private var rearArmStr = "73.0"

    @State private var baggageWeightStr = "30"
    @State private var baggageArmStr = "95.0"

    @State private var fuelGallonsStr = "40"
    @State private var fuelArmStr = "46.0"

    @State private var maxGrossWeightStr = "2300"
    @State private var minCGArmStr = "35.0"
    @State private var maxCGArmStr = "47.3"

    public init() {}

    private var emptyWeight: Double { Double(emptyWeightStr) ?? 0 }
    private var emptyArm: Double { Double(emptyArmStr) ?? 0 }

    private var pilotWeight: Double { Double(pilotWeightStr) ?? 0 }
    private var frontPassWeight: Double { Double(frontPassWeightStr) ?? 0 }
    private var frontArm: Double { Double(frontArmStr) ?? 0 }

    private var rearPassWeight: Double { Double(rearPassWeightStr) ?? 0 }
    private var rearArm: Double { Double(rearArmStr) ?? 0 }

    private var baggageWeight: Double { Double(baggageWeightStr) ?? 0 }
    private var baggageArm: Double { Double(baggageArmStr) ?? 0 }

    private var fuelGallons: Double { Double(fuelGallonsStr) ?? 0 }
    private var fuelWeight: Double { fuelGallons * 6.0 } // 6.0 lbs/gal for 100LL
    private var fuelArm: Double { Double(fuelArmStr) ?? 0 }

    private var maxGross: Double { Double(maxGrossWeightStr) ?? 2300 }
    private var minCG: Double { Double(minCGArmStr) ?? 35.0 }
    private var maxCG: Double { Double(maxCGArmStr) ?? 47.3 }

    private var totalWeight: Double {
        emptyWeight + pilotWeight + frontPassWeight + rearPassWeight + baggageWeight + fuelWeight
    }

    private var totalMoment: Double {
        (emptyWeight * emptyArm) +
        ((pilotWeight + frontPassWeight) * frontArm) +
        (rearPassWeight * rearArm) +
        (baggageWeight * baggageArm) +
        (fuelWeight * fuelArm)
    }

    private var cgLocation: Double {
        totalWeight > 0 ? (totalMoment / totalWeight) : 0
    }

    private var isOverWeight: Bool {
        totalWeight > maxGross
    }

    private var isOutOfCG: Bool {
        cgLocation < minCG || cgLocation > maxCG
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Results Banner
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TOTAL WEIGHT")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(String(format: "%.0f lbs", totalWeight))
                                .font(.title.bold())
                                .foregroundStyle(isOverWeight ? FGTheme.clay : .white)
                            Text(String(format: "Max: %.0f lbs", maxGross))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("CENTER OF GRAVITY")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(String(format: "%.2f in", cgLocation))
                                .font(.title.bold())
                                .foregroundStyle(isOutOfCG ? FGTheme.clay : FGTheme.sage)
                            Text(String(format: "Limits: %.1f - %.1f in", minCG, maxCG))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Status pill
                    HStack {
                        Image(systemName: (!isOverWeight && !isOutOfCG) ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        Text((!isOverWeight && !isOutOfCG) ? "Within Weight & CG Limits" : "OUT OF ENVELOPE")
                            .font(.subheadline.bold())
                    }
                    .foregroundStyle((!isOverWeight && !isOutOfCG) ? FGTheme.sage : FGTheme.clay)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background((!isOverWeight && !isOutOfCG) ? FGTheme.sage.opacity(0.15) : FGTheme.clay.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Loading Stations
                VStack(alignment: .leading, spacing: 14) {
                    Text("Loading Stations (Weights & Arms)")
                        .font(.headline)
                        .foregroundStyle(FGTheme.gold)

                    StationRow(label: "Aircraft Empty", weight: $emptyWeightStr, arm: $emptyArmStr, unit: "lbs")
                    StationRow(label: "Pilot & Front Passenger", weight: Binding(
                        get: { String(format: "%.0f", pilotWeight + frontPassWeight) },
                        set: { if let v = Double($0) { pilotWeightStr = String(format: "%.0f", v / 2); frontPassWeightStr = String(format: "%.0f", v / 2) } }
                    ), arm: $frontArmStr, unit: "lbs")
                    StationRow(label: "Rear Passengers", weight: $rearPassWeightStr, arm: $rearArmStr, unit: "lbs")
                    StationRow(label: "Baggage Area", weight: $baggageWeightStr, arm: $baggageArmStr, unit: "lbs")
                    StationRow(label: "Fuel (\(Int(fuelGallons)) Gal @ 6 lb/gal)", weight: Binding(
                        get: { fuelGallonsStr },
                        set: { fuelGallonsStr = $0 }
                    ), arm: $fuelArmStr, unit: "gal")
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Aircraft Envelope Limits
                VStack(alignment: .leading, spacing: 14) {
                    Text("Envelope Limits")
                        .font(.headline)
                        .foregroundStyle(FGTheme.gold)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Max Gross (lbs)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("2300", text: $maxGrossWeightStr)
                                .numericKeyboard()
                                .padding(8)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Forward Limit (in)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("35.0", text: $minCGArmStr)
                                .decimalKeyboard()
                                .padding(8)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aft Limit (in)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("47.3", text: $maxCGArmStr)
                                .decimalKeyboard()
                                .padding(8)
                                .background(FGTheme.mist)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(FGTheme.night)
        .navigationTitle("Weight & Balance")
    }
}

private struct StationRow: View {
    let label: String
    @Binding var weight: String
    @Binding var arm: String
    let unit: String

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text("Wt (\(unit))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                TextField("0", text: $weight)
                    .numericKeyboard()
                    .frame(width: 60)
                    .padding(6)
                    .background(FGTheme.mist)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Arm (in)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                TextField("0", text: $arm)
                    .decimalKeyboard()
                    .frame(width: 55)
                    .padding(6)
                    .background(FGTheme.mist)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(.white)
            }
        }
    }
}
