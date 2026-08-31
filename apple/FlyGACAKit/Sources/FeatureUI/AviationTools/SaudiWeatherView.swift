import CoreModels
import SwiftUI

public struct SaudiWeatherView: View {
    @State private var selectedAirport = "OEJN"
    @State private var searchText = ""

    // Curated active aerodromes in KSA with real-world weather patterns
    private let stations: [(icao: String, nameEn: String, nameAr: String, metar: String, taf: String, cat: FlightRuleCategory, temp: Int, dew: Int, qnh: Int, windDir: Int, windKts: Int, vis: Double)] = [
        (
            "OEJN",
            "King Abdulaziz Intl, Jeddah",
            "مطار الملك عبدالعزيز الدولي، جدة",
            "OEJN 311000Z 32014KT 9999 FEW025 34/24 Q1011 NOSIG",
            "TAF OEJN 310500Z 3106/0112 33015KT 9999 SCT025 BECMG 3118/3120 36008KT 9999 NSC",
            .vfr,
            34,
            24,
            1011,
            320,
            14,
            10.0
        ),
        (
            "OERK",
            "King Khalid Intl, Riyadh",
            "مطار الملك خالد الدولي، الرياض",
            "OERK 311000Z 09012KT 9999 NSC 38/12 Q1014 NOSIG",
            "TAF OERK 310500Z 3106/0112 08012KT 9999 NSC BECMG 3116/3118 12008KT CAVOK",
            .vfr,
            38,
            12,
            1014,
            90,
            12,
            10.0
        ),
        (
            "OEDF",
            "King Fahd Intl, Dammam",
            "مطار الملك فهد الدولي، الدمام",
            "OEDF 311000Z 14010KT 8000 HZ NSC 39/26 Q1009 NOSIG",
            "TAF OEDF 310500Z 3106/0112 13012KT 8000 HZ NSC BECMG 3115/3117 18006KT 9999 NSW",
            .vfr,
            39,
            26,
            1009,
            140,
            10,
            5.0
        ),
        (
            "OEMA",
            "Prince Mohammad Intl, Madinah",
            "مطار الأمير محمد بن عبدالعزيز، المدينة",
            "OEMA 311000Z 28009KT 9999 CAVOK 37/14 Q1012 NOSIG",
            "TAF OEMA 310500Z 3106/0112 27010KT CAVOK BECMG 3118/3120 VRB04KT CAVOK",
            .vfr,
            37,
            14,
            1012,
            280,
            9,
            10.0
        ),
        (
            "OEAB",
            "Abha Regional Airport",
            "مطار أبها الإقليمي",
            "OEAB 311000Z 18016G26KT 5000 -TSRA SCT030CB BKN080 22/16 Q1020 TEMPO 3000 TSRA",
            "TAF OEAB 310500Z 3106/0112 17015KT 6000 SCT035CB TEMPO 3109/3115 3000 +TSRA BKN025",
            .mvfr,
            22,
            16,
            1020,
            180,
            16,
            3.1
        ),
        (
            "OETB",
            "Prince Sultan Intl, Tabuk",
            "مطار الأمير سلطان الدولي، تبوك",
            "OETB 311000Z 30015KT 9999 NSC 33/08 Q1015 NOSIG",
            "TAF OETB 310500Z 3106/0112 30014KT 9999 CAVOK",
            .vfr,
            33,
            8,
            1015,
            300,
            15,
            10.0
        ),
        (
            "OETF",
            "Taif Regional Airport",
            "مطار الطائف الإقليمي",
            "OETF 311000Z 21010KT 9999 FEW035 28/14 Q1018 NOSIG",
            "TAF OETF 310500Z 3106/0112 20010KT 9999 SCT040 BECMG 3118/3120 VRB03KT NSC",
            .vfr,
            28,
            14,
            1018,
            210,
            10,
            10.0
        ),
        (
            "OEGN",
            "Jizan Regional Airport",
            "مطار الملك عبدالله، جازان",
            "OEGN 311000Z 20014KT 7000 HZ FEW025 35/27 Q1008 NOSIG",
            "TAF OEGN 310500Z 3106/0112 21014KT 8000 HZ SCT025",
            .vfr,
            35,
            27,
            1008,
            200,
            14,
            4.3
        )
    ]

    public init() {}

    private var currentStation: (icao: String, nameEn: String, nameAr: String, metar: String, taf: String, cat: FlightRuleCategory, temp: Int, dew: Int, qnh: Int, windDir: Int, windKts: Int, vis: Double) {
        stations.first { $0.icao == selectedAirport } ?? stations[0]
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Airport Selector Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(stations, id: \.icao) { stn in
                            Button {
                                selectedAirport = stn.icao
                            } label: {
                                VStack(spacing: 2) {
                                    Text(stn.icao)
                                        .font(.subheadline.bold())
                                    Text(stn.cat.rawValue)
                                        .font(.system(size: 9, weight: .black))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedAirport == stn.icao ? FGTheme.teal : FGTheme.deep)
                                .foregroundStyle(selectedAirport == stn.icao ? .white : .secondary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Station Overview Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentStation.icao)
                                .font(.title.bold())
                                .foregroundStyle(FGTheme.gold)
                            Text(currentStation.nameEn)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            Text(currentStation.nameAr)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(currentStation.cat.rawValue)
                                .font(.headline.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(categoryColor(currentStation.cat).opacity(0.2))
                                .foregroundStyle(categoryColor(currentStation.cat))
                                .clipShape(Capsule())
                            Text("FLIGHT RULES")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Decoded Weather Grid
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        WeatherTile(
                            icon: "wind",
                            label: "WIND",
                            value: "\(currentStation.windDir)° @ \(currentStation.windKts) kts"
                        )
                        WeatherTile(
                            icon: "eye.fill",
                            label: "VISIBILITY",
                            value: String(format: "%.1f SM", currentStation.vis)
                        )
                    }

                    HStack(spacing: 12) {
                        WeatherTile(
                            icon: "thermometer.medium",
                            label: "TEMP / DEW",
                            value: "\(currentStation.temp)°C / \(currentStation.dew)°C"
                        )
                        WeatherTile(
                            icon: "gauge.with.needle",
                            label: "ALTIMETER (QNH)",
                            value: "\(currentStation.qnh) hPa"
                        )
                    }
                }
                .padding(.horizontal)

                // Raw METAR Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(FGTheme.gold)
                        Text("RAW METAR")
                            .font(.caption.bold())
                            .foregroundStyle(FGTheme.gold)
                        Spacer()
                    }

                    Text(currentStation.metar)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Raw TAF Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundStyle(FGTheme.teal)
                        Text("AERODROME FORECAST (TAF)")
                            .font(.caption.bold())
                            .foregroundStyle(FGTheme.teal)
                        Spacer()
                    }

                    Text(currentStation.taf)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(FGTheme.mist)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
                .background(FGTheme.deep)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(FGTheme.night)
        .navigationTitle("Saudi Aviation Weather")
    }

    private func categoryColor(_ cat: FlightRuleCategory) -> Color {
        switch cat {
        case .vfr: return FGTheme.sage
        case .mvfr: return FGTheme.teal
        case .ifr: return FGTheme.clay
        case .lifr: return .purple
        }
    }
}

private struct WeatherTile: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(FGTheme.gold)
                Text(label)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.headline.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(FGTheme.deep)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
