import SwiftUI

public struct FlightDeckToolsView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 6) {
                        Text(Loc.t("tool.hub.title"))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(FGTheme.goldGlow)
                        Text(Loc.t("tool.hub.sub"))
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                    .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.12)

                    // Navigation & Primary Cockpit Display
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FLIGHT DECK INSTRUMENTS & ATC")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(FGTheme.cyanGlow)

                        NavigationLink {
                            CockpitHUDView()
                        } label: {
                            ToolRow(
                                icon: "airplane.circle.fill",
                                iconColor: FGTheme.goldGlow,
                                title: "Cockpit HUD & Primary Flight Display",
                                subtitle: "Artificial horizon, attitude indicator, airspeed & altimeter tapes"
                            )
                        }

                        NavigationLink {
                            RadioVoicePracticeView()
                        } label: {
                            ToolRow(
                                icon: "mic.badge.waveform.fill",
                                iconColor: FGTheme.cyanGlow,
                                title: "ATC Radio Voice & Phraseology",
                                subtitle: "Push-To-Talk cockpit transmitter & ICAO Level 4 check-ride drills"
                            )
                        }

                        NavigationLink {
                            SaudiWeatherView()
                        } label: {
                            ToolRow(
                                icon: "cloud.sun.rain.fill",
                                iconColor: FGTheme.sage,
                                title: Loc.t("tool.weather.title"),
                                subtitle: Loc.t("tool.weather.sub")
                            )
                        }
                    }

                    // Performance & Flight Planning Calculators
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PERFORMANCE & FLIGHT PLANNING")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(FGTheme.goldGlow)

                        NavigationLink {
                            CrosswindCalculatorView()
                        } label: {
                            ToolRow(
                                icon: "wind",
                                iconColor: FGTheme.teal,
                                title: Loc.t("tool.crosswind.title"),
                                subtitle: Loc.t("tool.crosswind.sub")
                            )
                        }

                        NavigationLink {
                            DensityAltitudeView()
                        } label: {
                            ToolRow(
                                icon: "mountain.2.fill",
                                iconColor: FGTheme.sage,
                                title: Loc.t("tool.density.title"),
                                subtitle: Loc.t("tool.density.sub")
                            )
                        }

                        NavigationLink {
                            WeightAndBalanceView()
                        } label: {
                            ToolRow(
                                icon: "scalemass.fill",
                                iconColor: FGTheme.gold,
                                title: Loc.t("tool.wb.title"),
                                subtitle: Loc.t("tool.wb.sub")
                            )
                        }

                        NavigationLink {
                            FuelPlannerView()
                        } label: {
                            ToolRow(
                                icon: "fuelpump.fill",
                                iconColor: FGTheme.clay,
                                title: Loc.t("tool.fuel.title"),
                                subtitle: Loc.t("tool.fuel.sub")
                            )
                        }

                        NavigationLink {
                            TimeSpeedDistanceView()
                        } label: {
                            ToolRow(
                                icon: "clock.arrow.circlepath",
                                iconColor: FGTheme.cyanGlow,
                                title: Loc.t("tool.tsd.title"),
                                subtitle: Loc.t("tool.tsd.sub")
                            )
                        }

                        NavigationLink {
                            UnitConverterView()
                        } label: {
                            ToolRow(
                                icon: "arrow.triangle.2.circlepath",
                                iconColor: FGTheme.sage,
                                title: Loc.t("tool.unit.title"),
                                subtitle: Loc.t("tool.unit.sub")
                            )
                        }
                    }
                }
                .padding()
            }
            .cockpitBackground()
            .navigationTitle(Loc.t("tab.flightDeck"))
        }
    }
}

private struct ToolRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(iconColor)
        }
        .padding(14)
        .background(FGTheme.deep.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(iconColor.opacity(0.25), lineWidth: 1)
        )
    }
}
