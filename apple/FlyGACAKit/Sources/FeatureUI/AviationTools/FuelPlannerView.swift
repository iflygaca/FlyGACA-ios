import SwiftUI

public struct FuelPlannerView: View {
    @State private var distanceStr = "180"
    @State private var groundSpeedStr = "110"
    @State private var burnRateStr = "9.5"
    @State private var usableFuelStr = "48"
    @State private var taxiFuelStr = "1.5"
    @State private var reserveMode = 0 // 0: VFR Day (30m), 1: VFR Night (45m), 2: IFR (45m + alternate)

    public init() {}

    private var distance: Double { Double(distanceStr) ?? 0 }
    private var groundSpeed: Double { max(1, Double(groundSpeedStr) ?? 100) }
    private var burnRate: Double { Double(burnRateStr) ?? 8.5 }
    private var usableFuel: Double { Double(usableFuelStr) ?? 40 }
    private var taxiFuel: Double { Double(taxiFuelStr) ?? 1.5 }

    private var flightTimeHours: Double {
        distance / groundSpeed
    }

    private var tripFuel: Double {
        flightTimeHours * burnRate
    }

    private var reserveMinutes: Double {
        switch reserveMode {
        case 0: return 30.0 // GACAR Part 91 VFR Day
        case 1: return 45.0 // GACAR Part 91 VFR Night
        default: return 60.0 // IFR (45m + 15m alternate)
        }
    }

    private var reserveFuel: Double {
        (reserveMinutes / 60.0) * burnRate
    }

    private var totalRequiredFuel: Double {
        taxiFuel + tripFuel + reserveFuel
    }

    private var remainingFuel: Double {
        usableFuel - (taxiFuel + tripFuel)
    }

    private var totalEnduranceHours: Double {
        burnRate > 0 ? (usableFuel - taxiFuel) / burnRate : 0
    }

    private var maxSafeRangeNM: Double {
        burnRate > 0 ? ((usableFuel - taxiFuel - reserveFuel) / burnRate) * groundSpeed : 0
    }

    private var isFuelSufficient: Bool {
        usableFuel >= totalRequiredFuel
    }

    private var eteFormatted: String {
        let hrs = Int(flightTimeHours)
        let mins = Int((flightTimeHours - Double(hrs)) * 60)
        return "\(hrs)h \(mins)m"
    }

    private var enduranceFormatted: String {
        let endHrs = Int(totalEnduranceHours)
        let endMins = Int((totalEnduranceHours - Double(endHrs)) * 60)
        return "\(endHrs)h \(endMins)m"
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Flight Parameters")
                .font(.headline)
                .foregroundStyle(FGTheme.gold)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Distance (NM)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("180", text: $distanceStr)
                        .numericKeyboard()
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Est. Groundspeed (kts)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("110", text: $groundSpeedStr)
                        .numericKeyboard()
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                }
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fuel Burn (GPH)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("9.5", text: $burnRateStr)
                        .decimalKeyboard()
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Usable Fuel (Gal)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("48", text: $usableFuelStr)
                        .decimalKeyboard()
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("GACAR Reserve Rule")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Reserve Rule", selection: $reserveMode) {
                    Text("VFR Day (30m)").tag(0)
                    Text("VFR Night (45m)").tag(1)
                    Text("IFR (+Alt)").tag(2)
                }
                .pickerStyle(.segmented)
            }
        }
        .padding()
        .background(FGTheme.deep)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var resultsCard: some View {
        VStack(spacing: 16) {
            Text("Fuel & Range Breakdown")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Hero Fuel Card
            VStack(spacing: 6) {
                Text("TOTAL FUEL REQUIRED")
                    .font(.caption.bold())
                    .foregroundStyle(FGTheme.gold)
                Text(String(format: "%.1f Gal", totalRequiredFuel))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(isFuelSufficient ? FGTheme.sage : FGTheme.clay)
                Text(String(format: "Trip: %.1f Gal · Reserve: %.1f Gal · Taxi: %.1f Gal", tripFuel, reserveFuel, taxiFuel))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(FGTheme.mist)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Flight ETE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(eteFormatted)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(FGTheme.mist)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Max Safe Range")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.0f NM", maxSafeRangeNM))
                        .font(.title3.bold())
                        .foregroundStyle(FGTheme.teal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(FGTheme.mist)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fuel on Landing")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f Gal", remainingFuel))
                        .font(.title3.bold())
                        .foregroundStyle(remainingFuel >= reserveFuel ? FGTheme.sage : FGTheme.clay)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(FGTheme.mist)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Endurance")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(enduranceFormatted)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(FGTheme.mist)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if !isFuelSufficient {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(FGTheme.clay)
                    Text("Insufficient Fuel: You need \(String(format: "%.1f", totalRequiredFuel - usableFuel)) more gallons to meet GACAR Part 91 minimum reserves!")
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

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                inputCard
                resultsCard
            }
            .padding()
        }
        .background(FGTheme.night)
        .navigationTitle("Fuel & Range Planner")
    }
}
