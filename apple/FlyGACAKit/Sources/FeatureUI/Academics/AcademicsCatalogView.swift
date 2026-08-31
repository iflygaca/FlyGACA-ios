import ContentKit
import CoreModels
import PersistenceKit
import SwiftUI

public struct AcademicsCatalogView: View {
    public let modules: [String: ModuleContent]
    public let catalog: [CatalogItem]
    public let store: StudyStore?

    @State private var selectedCategory = "all"
    @State private var searchText = ""

    public init(
        modules: [String: ModuleContent],
        catalog: [CatalogItem],
        store: StudyStore?
    ) {
        self.modules = modules
        self.catalog = catalog
        self.store = store
    }

    private var filteredCatalog: [CatalogItem] {
        catalog.filter { item in
            let matchCat = selectedCategory == "all" || item.category == selectedCategory
            let matchSearch = searchText.isEmpty ||
                item.nameEn.localizedCaseInsensitiveContains(searchText) ||
                item.nameAr.localizedCaseInsensitiveContains(searchText) ||
                item.badge.localizedCaseInsensitiveContains(searchText)
            return matchCat && matchSearch
        }
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Category Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterPill(label: "All Modules", tag: "all", selected: $selectedCategory)
                            FilterPill(label: "Pilot Licensing", tag: "licensing", selected: $selectedCategory)
                            FilterPill(label: "Ratings & AIP", tag: "ratings", selected: $selectedCategory)
                        }
                        .padding(.horizontal)
                    }

                    // Modules List
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCatalog) { item in
                            if let content = modules[item.id] {
                                NavigationLink {
                                    ModuleHomeView(content: content, store: store)
                                        .navigationTitle(item.nameEn)
                                } label: {
                                    CatalogCard(item: item, content: content)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .cockpitBackground()
            .navigationTitle("Academics")
            .searchable(text: $searchText, prompt: "Search PPL, CPL, IR, ATPL, ELPT...")
        }
    }
}

private struct FilterPill: View {
    let label: String
    let tag: String
    @Binding var selected: String

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selected = tag
            }
            HapticFeedback.selection()
        } label: {
            Text(label)
                .font(.subheadline.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(selected == tag ? FGTheme.teal : FGTheme.surface)
                .foregroundStyle(selected == tag ? .white : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(selected == tag ? FGTheme.cyanGlow : FGTheme.mist, lineWidth: 1)
                )
                .shadow(color: selected == tag ? FGTheme.teal.opacity(0.3) : Color.clear, radius: 8)
        }
    }
}

private struct CatalogCard: View {
    let item: CatalogItem
    let content: ModuleContent

    private var questionCount: Int {
        content.quiz.banks.reduce(0) { $0 + $1.questions.count }
    }

    private var lessonsCount: Int {
        content.groundSchool?.modules.count ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(FGTheme.gold.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundStyle(FGTheme.goldGlow)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(item.nameEn)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                        Spacer()
                        Text(item.badge)
                            .font(.system(size: 10, weight: .black))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(FGTheme.teal)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    Text(item.nameAr)
                        .font(.caption)
                        .foregroundStyle(FGTheme.sage)
                }
            }

            Text(item.summaryEn)
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.8))
                .lineLimit(2)

            Divider()
                .background(FGTheme.mist)

            HStack(spacing: 16) {
                Label("\(content.quiz.banks.count) Banks", systemImage: "tray.2.fill")
                Label("\(questionCount) Questions", systemImage: "checkmark.seal.fill")
                if lessonsCount > 0 {
                    Label("\(lessonsCount) Lessons", systemImage: "book.fill")
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(FGTheme.goldGlow)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.08)
    }
}
