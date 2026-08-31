import ContentKit
import CoreModels
import PersistenceKit
import StudyEngines
import SwiftUI

public struct MainDashboardView: View {
    public let modules: [String: ModuleContent]
    public let catalog: [CatalogItem]
    public let store: StudyStore?
    public let onSelectTab: (Int) -> Void

    @State private var streakCount = 0
    @State private var pastExams: [PastExam] = []
    @State private var showSettings = false

    public init(
        modules: [String: ModuleContent],
        catalog: [CatalogItem],
        store: StudyStore?,
        onSelectTab: @escaping (Int) -> Void
    ) {
        self.modules = modules
        self.catalog = catalog
        self.store = store
        self.onSelectTab = onSelectTab
    }

    private var totalQuestionsCount: Int {
        modules.values.reduce(0) { total, mod in
            total + mod.quiz.banks.reduce(0) { $0 + $1.questions.count }
        }
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Pilot Greeting & Streak Banner
                    HStack(spacing: 16) {
                        // Pilot Avatar / Wings Badge
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [FGTheme.goldGlow, FGTheme.gold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 52, height: 52)
                                .shadow(color: FGTheme.gold.opacity(0.4), radius: 8)
                            Image(systemName: "airplane.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(FGTheme.night)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(Loc.t("dash.captainDeck"))
                                .font(.title3.weight(.black))
                                .foregroundStyle(.white)
                            Text("FLIGHT DECK COMMAND · GACA VFR/IFR")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundStyle(FGTheme.teal)
                        }

                        Spacer()

                        // Streak Flame Badge
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.title3)
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(streakCount)")
                                    .font(.system(.title3, design: .monospaced, weight: .black))
                                    .foregroundStyle(.white)
                                Text(Loc.t("dash.dayStreak"))
                                    .font(.system(size: 8, weight: .black))
                                    .foregroundStyle(FGTheme.gold)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(FGTheme.surface)
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(FGTheme.gold.opacity(0.3), lineWidth: 1))
                    }
                    .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.1)

                    // Quick Resume / Featured Module
                    if let firstItem = catalog.first, let firstContent = modules[firstItem.id] {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(FGTheme.cyanGlow)
                                        .frame(width: 6, height: 6)
                                    Text("FEATURED RATING")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundStyle(FGTheme.cyanGlow)
                                }
                                Spacer()
                                Text(firstItem.badge)
                                    .font(.system(size: 10, weight: .black))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3)
                                    .background(FGTheme.teal)
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                            }

                            Text(firstItem.nameEn)
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.white)

                            Text(firstItem.summaryEn)
                                .font(.footnote)
                                .foregroundStyle(Color.white.opacity(0.75))
                                .lineLimit(2)

                            NavigationLink {
                                ModuleHomeView(content: firstContent, store: store)
                                    .navigationTitle(firstItem.nameEn)
                            } label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text(Loc.t("dash.continueDeck"))
                                }
                                .font(.subheadline.weight(.black))
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(FGTheme.brandGradient)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .shadow(color: FGTheme.teal.opacity(0.4), radius: 10, y: 4)
                            }
                        }
                        .glassCard(glowColor: FGTheme.teal, glowOpacity: 0.12)
                    }

                    // Study Readiness Overview Grid
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(Loc.t("dash.examReadiness"))
                                .font(.headline.weight(.bold))
                                .foregroundStyle(FGTheme.gold)
                            Spacer()
                            Button {
                                onSelectTab(1) // Academics Tab
                            } label: {
                                HStack(spacing: 4) {
                                    Text(Loc.t("dash.allModules", catalog.count))
                                        .font(.caption.bold())
                                    Image(systemName: "chevron.right")
                                        .font(.caption2.bold())
                                }
                                .foregroundStyle(FGTheme.cyanGlow)
                            }
                        }

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(
                                title: Loc.t("dash.corpus"),
                                value: "\(totalQuestionsCount)",
                                subtitle: "\(modules.count) Active Modules",
                                icon: "books.vertical.fill",
                                color: FGTheme.teal
                            )
                            StatCard(
                                title: Loc.t("dash.attempts"),
                                value: "\(pastExams.count)",
                                subtitle: Loc.t("dash.passed", pastExams.filter { $0.passed }.count),
                                icon: "checkmark.seal.fill",
                                color: FGTheme.sage
                            )
                        }
                    }
                    .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.08)

                    // Quick Flight Deck Tools
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(Loc.t("dash.flightDeckTools"))
                                .font(.headline.weight(.bold))
                                .foregroundStyle(FGTheme.gold)
                            Spacer()
                            Button {
                                onSelectTab(2) // Flight Deck Tab
                            } label: {
                                HStack(spacing: 4) {
                                    Text(Loc.t("dash.openHub"))
                                        .font(.caption.bold())
                                    Image(systemName: "chevron.right")
                                        .font(.caption2.bold())
                                }
                                .foregroundStyle(FGTheme.cyanGlow)
                            }
                        }

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ToolShortcut(
                                icon: "airplane.circle.fill",
                                label: "Cockpit HUD",
                                color: FGTheme.gold,
                                destination: CockpitHUDView()
                            )
                            ToolShortcut(
                                icon: "mic.badge.waveform.fill",
                                label: "ATC Radio",
                                color: FGTheme.cyanGlow,
                                destination: RadioVoicePracticeView()
                            )
                            ToolShortcut(
                                icon: "wind",
                                label: "Crosswind",
                                color: FGTheme.teal,
                                destination: CrosswindCalculatorView()
                            )
                            ToolShortcut(
                                icon: "cloud.sun.rain.fill",
                                label: "METAR WX",
                                color: FGTheme.sage,
                                destination: SaudiWeatherView()
                            )
                        }
                    }
                    .glassCard(glowColor: FGTheme.cyanGlow, glowOpacity: 0.08)

                    // Captain Adel AI Prompt Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(FGTheme.gold.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "airplane")
                                    .font(.title3)
                                    .foregroundStyle(FGTheme.goldGlow)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(Loc.t("dash.adelTitle"))
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.white)
                                Text(Loc.t("dash.adelSubtitle"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }

                        Text(Loc.t("dash.adelDesc"))
                            .font(.footnote)
                            .foregroundStyle(Color.white.opacity(0.8))

                        Button {
                            onSelectTab(3) // Captain Adel Tab
                        } label: {
                            HStack {
                                Image(systemName: "sparkles")
                                Text(Loc.t("dash.askAdel"))
                            }
                            .font(.subheadline.weight(.black))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(FGTheme.surface)
                            .foregroundStyle(FGTheme.goldGlow)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(FGTheme.gold.opacity(0.4), lineWidth: 1)
                            )
                        }
                    }
                    .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.12)

                    // Disclaimer
                    Disclaimer()
                }
                .padding()
            }
            .cockpitBackground()
            .navigationTitle("Fly GACA")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(FGTheme.gold)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(store: store)
            }
            .task {
                if let store {
                    streakCount = (try? await store.currentStreak())?.count ?? 0
                    pastExams = (try? await store.examHistory(moduleID: "ppl-exam")) ?? []
                }
            }
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(color)
                Spacer()
            }
            Text(value)
                .font(.system(.title2, design: .monospaced, weight: .black))
                .foregroundStyle(.white)
            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
            Text(subtitle)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(color)
        }
        .padding(12)
        .background(FGTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct ToolShortcut<Dest: View>: View {
    let icon: String
    let label: String
    let color: Color
    let destination: Dest

    var body: some View {
        NavigationLink {
            destination
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(color)
                }
                Text(label)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(FGTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(FGTheme.mist, lineWidth: 1)
            )
        }
    }
}
