import SwiftUI

public struct UnitConverterView: View {
    @State private var inputValStr = "100"
    @State private var selectedCategory = 0

    private let categories = ["Speed", "Distance", "Altitude", "Pressure", "Weight", "Fuel", "Temp"]

    public init() {}

    private var inputVal: Double { Double(inputValStr) ?? 0 }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<categories.count, id: \.self) { idx in
                            Button {
                                selectedCategory = idx
                            } label: {
                                Text(categories[idx])
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == idx ? FGTheme.teal : FGTheme.deep)
                                    .foregroundStyle(selectedCategory == idx ? .white : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Input card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Base Value")
                        .font(.caption)
                        .foregroundStyle(FGTheme.gold)
                    TextField("100", text: $inputValStr)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .decimalKeyboard()
                        .padding()
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Conversions Matrix
                VStack(spacing: 12) {
                    switch selectedCategory {
                    case 0: // Speed
                        ConversionTile(label: "Knots (kts)", value: String(format: "%.1f", inputVal), base: true)
                        ConversionTile(label: "Miles per Hour (mph)", value: String(format: "%.1f", inputVal * 1.15078))
                        ConversionTile(label: "Kilometers per Hour (km/h)", value: String(format: "%.1f", inputVal * 1.852))
                        ConversionTile(label: "Meters per Second (m/s)", value: String(format: "%.1f", inputVal * 0.514444))

                    case 1: // Distance
                        ConversionTile(label: "Nautical Miles (NM)", value: String(format: "%.2f", inputVal), base: true)
                        ConversionTile(label: "Statute Miles (SM)", value: String(format: "%.2f", inputVal * 1.15078))
                        ConversionTile(label: "Kilometers (km)", value: String(format: "%.2f", inputVal * 1.852))
                        ConversionTile(label: "Feet (ft)", value: String(format: "%.0f", inputVal * 6076.12))
                        ConversionTile(label: "Meters (m)", value: String(format: "%.0f", inputVal * 1852.0))

                    case 2: // Altitude
                        ConversionTile(label: "Feet (ft)", value: String(format: "%.0f", inputVal), base: true)
                        ConversionTile(label: "Flight Level (FL)", value: String(format: "FL%03.0f", inputVal / 100))
                        ConversionTile(label: "Meters (m)", value: String(format: "%.1f", inputVal * 0.3048))

                    case 3: // Pressure
                        ConversionTile(label: "Hectopascals / Millibars (hPa/mb)", value: String(format: "%.1f", inputVal), base: true)
                        ConversionTile(label: "Inches of Mercury (inHg)", value: String(format: "%.2f", inputVal * 0.02953))
                        ConversionTile(label: "Millimeters of Mercury (mmHg)", value: String(format: "%.1f", inputVal * 0.750062))

                    case 4: // Weight
                        ConversionTile(label: "Pounds (lbs)", value: String(format: "%.1f", inputVal), base: true)
                        ConversionTile(label: "Kilograms (kg)", value: String(format: "%.1f", inputVal * 0.453592))

                    case 5: // Fuel
                        ConversionTile(label: "US Gallons (gal)", value: String(format: "%.1f", inputVal), base: true)
                        ConversionTile(label: "Liters (L)", value: String(format: "%.1f", inputVal * 3.78541))
                        ConversionTile(label: "Avgas 100LL Weight (lbs)", value: String(format: "%.1f", inputVal * 6.0))
                        ConversionTile(label: "Jet A-1 Weight (lbs)", value: String(format: "%.1f", inputVal * 6.7))
                        ConversionTile(label: "Jet A-1 Weight (kg)", value: String(format: "%.1f", inputVal * 3.039))

                    default: // Temp
                        ConversionTile(label: "Celsius (°C)", value: String(format: "%.1f", inputVal), base: true)
                        ConversionTile(label: "Fahrenheit (°F)", value: String(format: "%.1f", (inputVal * 9/5) + 32))
                        ConversionTile(label: "Kelvin (K)", value: String(format: "%.1f", inputVal + 273.15))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(FGTheme.night)
        .navigationTitle("Aviation Unit Converter")
    }
}

private struct ConversionTile: View {
    let label: String
    let value: String
    var base: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(base ? FGTheme.gold : .secondary)
            Spacer()
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(base ? .white : FGTheme.teal)
        }
        .padding()
        .background(base ? FGTheme.mist : FGTheme.deep)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
