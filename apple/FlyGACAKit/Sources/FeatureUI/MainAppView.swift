import ContentKit
import CoreModels
import PersistenceKit
import SwiftUI

public struct MainAppView: View {
    public let store: StudyStore?

    @State private var selectedTab = 0
    @State private var loadState: LoadState = .loading
    @State private var showSettings = false

    public enum LoadState {
        case loading
        case failed(String)
        case loaded(modules: [String: ModuleContent], catalog: [CatalogItem], regulations: GACARIndex?)
    }

    public init(store: StudyStore? = nil) {
        self.store = store
    }

    public var body: some View {
        Group {
            switch loadState {
            case .loading:
                ZStack {
                    FGTheme.night.ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(FGTheme.gold)
                        Text("Loading Fly GACA Flight Deck...")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

            case .failed(let error):
                NavigationStack {
                    ZStack {
                        FGTheme.night.ignoresSafeArea()
                        ContentUnavailableView {
                            Label(Loc.t("content.unavailable.title"), systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(error)
                        }
                    }
                }

            case .loaded(let modules, let catalog, let regulations):
                TabView(selection: $selectedTab) {
                    MainDashboardView(
                        modules: modules,
                        catalog: catalog,
                        store: store,
                        onSelectTab: { tab in selectedTab = tab }
                    )
                    .tabItem {
                        Label(Loc.t("tab.home"), systemImage: "house.fill")
                    }
                    .tag(0)

                    AcademicsCatalogView(
                        modules: modules,
                        catalog: catalog,
                        store: store
                    )
                    .tabItem {
                        Label(Loc.t("tab.academics"), systemImage: "graduationcap.fill")
                    }
                    .tag(1)

                    FlightDeckToolsView()
                        .tabItem {
                            Label(Loc.t("tab.flightDeck"), systemImage: "gauge.with.needle.fill")
                        }
                        .tag(2)

                    CaptainAdelChatView()
                        .tabItem {
                            Label(Loc.t("tab.captainAdel"), systemImage: "airplane")
                        }
                        .tag(3)

                    RegulationsLibraryView(regulationsIndex: regulations)
                        .tabItem {
                            Label(Loc.t("tab.regulations"), systemImage: "book.closed.fill")
                        }
                        .tag(4)
                }
                .tint(FGTheme.gold)
            }
        }
        .task { load() }
    }

    private func load() {
        guard let directory = ContentLoader.bundledContentDirectory() else {
            // Fallback for tests / preview
            loadState = .failed("Content directory not found in bundle.")
            return
        }

        let contentStore = ContentStore(bundledDirectory: directory)
        let modules = contentStore.loadAllModules()
        let catalog = contentStore.loadCatalog()
        let regulations = contentStore.loadRegulations()

        if modules.isEmpty {
            // Check if single module fallback
            if let single = try? contentStore.load() {
                loadState = .loaded(
                    modules: [single.manifest.id: single],
                    catalog: [CatalogItem(
                        id: single.manifest.id,
                        folder: single.manifest.id,
                        nameEn: SingleModuleRootView.displayName(for: single.manifest.id),
                        nameAr: SingleModuleRootView.displayName(for: single.manifest.id),
                        badge: single.manifest.id.uppercased(),
                        category: "licensing",
                        icon: "airplane",
                        summaryEn: "Aviation study pack for Saudi pilots.",
                        summaryAr: "حقيبة دراسية متخصصة للطيارين في المملكة العربية السعودية."
                    )],
                    regulations: regulations
                )
                return
            }
            loadState = .failed("No modules could be loaded from Content directory.")
            return
        }

        loadState = .loaded(modules: modules, catalog: catalog, regulations: regulations)
    }
}
