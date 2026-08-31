import CoreModels
import SwiftUI

public struct RegulationsLibraryView: View {
    public let regulationsIndex: GACARIndex?

    @State private var selectedCategory = "all"
    @State private var searchText = ""

    public init(regulationsIndex: GACARIndex?) {
        self.regulationsIndex = regulationsIndex
    }

    private var categories: [GACARCategory] {
        regulationsIndex?.categories ?? [
            GACARCategory(id: "general", label: "General & Rulemaking"),
            GACARCategory(id: "licensing", label: "Personnel Licensing"),
            GACARCategory(id: "airspace", label: "Airspace & Flight Rules"),
            GACARCategory(id: "operations", label: "Air Operators & Aerodromes"),
            GACARCategory(id: "airworthiness", label: "Airworthiness & Maintenance")
        ]
    }

    private var allDocuments: [GACARDocument] {
        regulationsIndex?.documents ?? [
            GACARDocument(part: "1", partNum: 1, title: "Definitions, Abbreviations and Editorial Conventions", category: "general", slug: "part-1", pages: 239, outline: ["Subpart A — Definitions", "Subpart B — Abbreviations", "Subpart C — Editorial Conventions"]),
            GACARDocument(part: "61", partNum: 61, title: "Certification: Pilots, Flight Instructors, and Ground Instructors", category: "licensing", slug: "part-61", pages: 184, outline: ["Subpart A — General", "Subpart B — Aircraft Ratings and Pilot Authorizations", "Subpart C — Student Pilots", "Subpart D — Private Pilots", "Subpart E — Commercial Pilots", "Subpart F — Airline Transport Pilots", "Subpart G — Flight Instructors"]),
            GACARDocument(part: "91", partNum: 91, title: "General Operating and Flight Rules", category: "airspace", slug: "part-91", pages: 215, outline: ["Subpart A — General", "Subpart B — Flight Rules", "Subpart C — Equipment, Instrument, and Certificate Requirements", "Subpart D — Special Flight Operations", "Subpart E — Maintenance, Preventive Maintenance, and Alterations"]),
            GACARDocument(part: "121", partNum: 121, title: "Operating Requirements: Domestic, Flag, and Supplemental Operations", category: "operations", slug: "part-121", pages: 310, outline: ["Subpart A — General", "Subpart B — Certification Rules", "Subpart N — Training Program", "Subpart T — Flight Operations"]),
            GACARDocument(part: "141", partNum: 141, title: "Pilot Schools and Training Centers", category: "licensing", slug: "part-141", pages: 95, outline: ["Subpart A — General", "Subpart B — School Certificate", "Subpart C — Training Courses"])
        ]
    }

    private var filteredDocuments: [GACARDocument] {
        allDocuments.filter { doc in
            let matchCat = selectedCategory == "all" || doc.category == selectedCategory
            let matchSearch = searchText.isEmpty ||
                doc.title.localizedCaseInsensitiveContains(searchText) ||
                doc.part.localizedCaseInsensitiveContains(searchText)
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
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = "all"
                                }
                                HapticFeedback.selection()
                            } label: {
                                Text("All Parts (\(allDocuments.count))")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == "all" ? FGTheme.teal : FGTheme.surface)
                                    .foregroundStyle(selectedCategory == "all" ? .white : .secondary)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(selectedCategory == "all" ? FGTheme.cyanGlow : FGTheme.mist, lineWidth: 1)
                                    )
                            }

                            ForEach(categories) { cat in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCategory = cat.id
                                    }
                                    HapticFeedback.selection()
                                } label: {
                                    Text(cat.label)
                                        .font(.subheadline.bold())
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedCategory == cat.id ? FGTheme.teal : FGTheme.surface)
                                        .foregroundStyle(selectedCategory == cat.id ? .white : .secondary)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(selectedCategory == cat.id ? FGTheme.cyanGlow : FGTheme.mist, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Disclaimer notice
                    Disclaimer()
                        .padding(.horizontal)

                    // Documents List
                    LazyVStack(spacing: 14) {
                        ForEach(filteredDocuments) { doc in
                            NavigationLink {
                                RegulationDetailView(document: doc)
                            } label: {
                                RegulationCard(document: doc)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .cockpitBackground()
            .navigationTitle("GACAR Library")
            .searchable(text: $searchText, prompt: "Search Part number, e.g. 61, 91, 121...")
        }
    }
}

private struct RegulationCard: View {
    let document: GACARDocument

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(FGTheme.gold.opacity(0.15))
                    .frame(width: 54, height: 54)
                VStack(spacing: 0) {
                    Text("PART")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.goldGlow)
                    Text(document.part)
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.goldGlow)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(document.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 8) {
                    Text(document.category.capitalized)
                        .font(.caption2.bold())
                        .foregroundStyle(FGTheme.teal)
                    if let pages = document.pages {
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text("\(pages) pages")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(FGTheme.goldGlow)
        }
        .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.08)
    }
}

public struct RegulationDetailView: View {
    let document: GACARDocument

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header card
                VStack(alignment: .leading, spacing: 10) {
                    Text("GACAR PART \(document.part)")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.goldGlow)

                    Text(document.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    HStack(spacing: 16) {
                        Label(document.category.capitalized, systemImage: "folder.fill")
                        if let pages = document.pages {
                            Label("\(pages) pages", systemImage: "doc.fill")
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(FGTheme.cyanGlow)
                }
                .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.12)

                // Outline Subparts
                if let outline = document.outline, !outline.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Subpart Outline")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(FGTheme.goldGlow)

                        VStack(spacing: 8) {
                            ForEach(outline, id: \.self) { subpart in
                                HStack {
                                    Image(systemName: "bookmark.fill")
                                        .font(.caption)
                                        .foregroundStyle(FGTheme.teal)
                                    Text(subpart)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding(12)
                                .background(FGTheme.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }
                    }
                    .glassCard(glowColor: FGTheme.teal, glowOpacity: 0.08)
                }

                // Official Link card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Authoritative Publication")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("All regulations are published officially by the General Authority of Civil Aviation of Saudi Arabia.")
                        .font(.footnote)
                        .foregroundStyle(Color.white.opacity(0.8))

                    Link(destination: URL(string: "https://gaca.gov.sa")!) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Open Official GACA Portal (gaca.gov.sa)")
                        }
                        .font(.subheadline.weight(.bold))
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(FGTheme.brandGradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .glassCard(glowColor: FGTheme.cyanGlow, glowOpacity: 0.08)
            }
            .padding()
        }
        .cockpitBackground()
        .navigationTitle("Part \(document.part)")
    }
}
