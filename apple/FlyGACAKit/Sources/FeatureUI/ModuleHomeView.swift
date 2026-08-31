import ContentKit
import CoreModels
import PersistenceKit
import StudyEngines
import SwiftUI

/// The home screen every app in the family shares: the module's five core
/// features (study, quiz, flashcards, mock, timed exam) built entirely from the
/// module's content. White-label Liquid Glass surface.
struct ModuleHomeView: View {
    let content: ModuleContent
    /// Durable study store (nil ⇒ persistence disabled; the UI still works, it
    /// just doesn't save). Threaded to every screen that records progress.
    let store: StudyStore?

    private var bankTitles: [String: String] {
        Dictionary(uniqueKeysWithValues: content.quiz.banks.map { ($0.id, $0.title) })
    }

    private var moduleID: String { content.manifest.id }

    /// Every transcript-style question across all banks — feeds the Scenario
    /// Simulator. Empty for modules with no scenario content.
    private var scenarioQuestions: [Question] {
        content.quiz.banks.flatMap(\.questions).filter(ScenarioSimulatorView.isScenario)
    }

    /// Per-bank glyph — matched on the bank id's keywords so a new bank gets a
    /// sensible icon without any code change.
    private func icon(for bank: Bank) -> String {
        let id = bank.id
        if id.contains("scenario") { return "dot.radiowaves.left.and.right" }
        if id.contains("radio") { return "antenna.radiowaves.left.and.right" }
        if id.contains("phraseology") { return "text.bubble" }
        if id.contains("comprehension") { return "ear" }
        if id.contains("rating") { return "chart.bar" }
        return "questionmark.circle"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Ground School Section
                if let groundSchool = content.groundSchool {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Loc.t("home.section.study"))
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(FGTheme.cyanGlow)

                        ForEach(groundSchool.modules) { module in
                            NavigationLink {
                                LessonListScreen(module: module, store: store, moduleID: moduleID)
                            } label: {
                                SectionRow(
                                    icon: "book.fill",
                                    iconColor: FGTheme.cyanGlow,
                                    title: module.title,
                                    subtitle: module.summary
                                )
                            }
                        }
                    }
                    .glassCard(glowColor: FGTheme.cyanGlow, glowOpacity: 0.08)
                }

                // Scenario Simulator Section
                if !scenarioQuestions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Loc.t("home.section.simulator"))
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(FGTheme.goldGlow)

                        NavigationLink {
                            ScenarioSimulatorView(
                                questions: scenarioQuestions,
                                exam: content.exam,
                                bankTitles: bankTitles,
                                moduleID: moduleID,
                                store: store
                            )
                        } label: {
                            SectionRow(
                                icon: "headphones",
                                iconColor: FGTheme.goldGlow,
                                title: Loc.t("home.simulator.title"),
                                subtitle: Loc.t("home.simulator.subtitle", scenarioQuestions.count)
                            )
                        }
                    }
                    .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.1)
                }

                // Topic Quizzes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(Loc.t("home.section.quizByTopic"))
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.teal)

                    ForEach(content.quiz.banks) { bank in
                        NavigationLink {
                            QuizScreen(
                                title: bank.title,
                                session: StudySession(questions: bank.questions, config: .practice),
                                bankTitles: bankTitles,
                                moduleID: moduleID,
                                store: store,
                                bankID: bank.id
                            )
                        } label: {
                            SectionRow(
                                icon: icon(for: bank),
                                iconColor: FGTheme.teal,
                                title: bank.title,
                                subtitle: Loc.t("home.questionCount", bank.questions.count)
                            )
                        }
                    }
                }
                .glassCard(glowColor: FGTheme.teal, glowOpacity: 0.08)

                // Flashcards Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(Loc.t("home.section.flashcards"))
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.sage)

                    ForEach(content.quiz.banks) { bank in
                        NavigationLink {
                            FlashcardsScreen(bank: bank, store: store)
                        } label: {
                            SectionRow(
                                icon: "rectangle.on.rectangle.angled",
                                iconColor: FGTheme.sage,
                                title: bank.title,
                                subtitle: "Leitner SRS deck · \(bank.questions.count) cards"
                            )
                        }
                    }
                }
                .glassCard(glowColor: FGTheme.sage, glowOpacity: 0.08)

                // Exam Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(Loc.t("home.section.exam"))
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(FGTheme.goldGlow)

                    NavigationLink {
                        QuizScreen(
                            title: Loc.t("home.mockExam.title"),
                            session: StudySession(
                                questions: QuestionSampler.draw(
                                    from: content.quiz.banks, count: content.exam.questionCount),
                                config: .mock(content.exam)),
                            bankTitles: bankTitles,
                            moduleID: moduleID,
                            store: store,
                            bankID: nil
                        )
                    } label: {
                        SectionRow(
                            icon: "doc.questionmark",
                            iconColor: FGTheme.goldGlow,
                            title: Loc.t("home.mockExam.untimed"),
                            subtitle: "\(content.exam.questionCount) Questions · Immediate Feedback"
                        )
                    }

                    NavigationLink {
                        ExamScreen(content: content, bankTitles: bankTitles, moduleID: moduleID, store: store)
                    } label: {
                        SectionRow(
                            icon: "timer",
                            iconColor: FGTheme.clay,
                            title: Loc.t("home.exam.timed", content.exam.minutes, content.exam.passMark),
                            subtitle: "Official Timer · Strict Scoring"
                        )
                    }
                }
                .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.1)

                Disclaimer()
            }
            .padding()
        }
        .cockpitBackground()
    }
}

private struct SectionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(iconColor)
        }
        .padding(10)
        .background(FGTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

/// Read-only lesson list with a per-lesson "mark complete" toggle. Full lesson
/// bodies + Captain Adel hooks come in a later phase; completion state is durable
/// today (persisted via StudyStore, family-wide).
struct LessonListScreen: View {
    let module: GSModule
    let store: StudyStore?
    let moduleID: String

    @State private var doneIDs: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(module.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(FGTheme.goldGlow)
                    Text(module.summary)
                        .font(.subheadline)
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                .glassCard(glowColor: FGTheme.gold, glowOpacity: 0.1)

                VStack(spacing: 10) {
                    ForEach(module.lessons) { lesson in
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(lesson.title)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(lesson.objective)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.white.opacity(0.7))
                            }
                            Spacer()
                            Button {
                                markDone(lesson)
                            } label: {
                                Image(systemName: doneIDs.contains(lesson.id) ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(doneIDs.contains(lesson.id) ? FGTheme.sage : Color.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(Loc.t(doneIDs.contains(lesson.id) ? "a11y.completed" : "a11y.markComplete"))
                        }
                        .padding(14)
                        .background(FGTheme.deep)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(doneIDs.contains(lesson.id) ? FGTheme.sage.opacity(0.4) : FGTheme.mist, lineWidth: 1)
                        )
                    }
                }
            }
            .padding()
        }
        .cockpitBackground()
        .navigationTitle(module.title)
        .task { await loadDone() }
    }

    private func loadDone() async {
        guard let store else { return }
        if let done = try? await store.lessonsDone(moduleID: moduleID) {
            doneIDs = Set(done)
        }
    }

    private func markDone(_ lesson: GSLesson) {
        guard !doneIDs.contains(lesson.id) else { return }
        doneIDs.insert(lesson.id)
        HapticFeedback.success()
        guard let store else { return }
        Task {
            _ = try? await store.markLessonDone(moduleID: moduleID, lessonID: lesson.id)
            _ = try? await store.touchStreak()
        }
    }
}

struct QuizScreen: View {
    let title: String
    @State var session: StudySession
    let bankTitles: [String: String]
    let moduleID: String
    let store: StudyStore?
    /// Non-nil for a single-topic quiz (the bank's id ⇒ best-per-bank score);
    /// nil for the multi-bank mock exam (recorded as an exam attempt).
    let bankID: String?

    var body: some View {
        QuizView(session: session, bankTitles: bankTitles, onFinished: persist, onFlag: flag)
            .navigationTitle(title)
    }

    private func persist(_ result: SessionResult) {
        guard let store else { return }
        Task {
            if let bankID {
                _ = try? await store.recordQuizScore(
                    moduleID: moduleID, bankID: bankID, percent: result.percent)
            } else {
                _ = try? await store.recordExam(moduleID: moduleID, result: result)
            }
            _ = try? await store.touchStreak()
        }
    }

    private func flag(_ question: Question, flagged: Bool) {
        guard let store else { return }
        Task {
            _ = try? await store.setFlag(
                moduleID: moduleID, bankID: question.bankID, index: question.index, flagged: flagged)
        }
    }
}

struct ExamScreen: View {
    let content: ModuleContent
    let bankTitles: [String: String]
    let moduleID: String
    let store: StudyStore?
    @State private var session: StudySession

    init(content: ModuleContent, bankTitles: [String: String], moduleID: String, store: StudyStore?) {
        self.content = content
        self.bankTitles = bankTitles
        self.moduleID = moduleID
        self.store = store
        _session = State(
            initialValue: StudySession(
                questions: QuestionSampler.draw(
                    from: content.quiz.banks, count: content.exam.questionCount),
                config: .exam(content.exam)
            ))
    }

    var body: some View {
        QuizView(session: session, bankTitles: bankTitles, onFinished: persist, onFlag: flag)
            .navigationTitle(content.exam.title ?? Loc.t("exam.timed.fallbackTitle"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ExamTimerView(session: session)
                }
            }
    }

    private func persist(_ result: SessionResult) {
        guard let store else { return }
        Task {
            _ = try? await store.recordExam(moduleID: moduleID, result: result)
            _ = try? await store.touchStreak()
        }
    }

    private func flag(_ question: Question, flagged: Bool) {
        guard let store else { return }
        Task {
            _ = try? await store.setFlag(
                moduleID: moduleID, bankID: question.bankID, index: question.index, flagged: flagged)
        }
    }
}

/// Flip-card runner over one bank. Grading updates a local snapshot for the
/// instant "Deck complete" mastery count AND persists the durable Leitner
/// schedule + streak through StudyStore (family-wide, survives relaunch).
struct FlashcardsScreen: View {
    let bank: Bank
    let store: StudyStore?
    @State private var index = 0
    @State private var srs: [String: SrsEntry] = [:]
    /// The cards due for review, in bank order — snapshotted once per session so
    /// grading a card mid-deck doesn't reshuffle the remaining queue.
    @State private var deck: [Question] = []

    var body: some View {
        VStack {
            if let question = card {
                Text(Loc.t("flashcards.cardProgress", index + 1, deck.count))
                    .font(.system(.caption, design: .monospaced, weight: .bold))
                    .foregroundStyle(FGTheme.cyanGlow)
                    .padding(.top)

                FlashcardView(
                    front: question.prompt,
                    back: "\(question.correctChoice)\n\n\(question.explanation)"
                ) { correct in
                    grade(question: question, correct: correct)
                }
            } else {
                ContentUnavailableView {
                    Label(Loc.t("flashcards.deckComplete"), systemImage: "checkmark.seal.fill")
                        .foregroundStyle(FGTheme.sage)
                } description: {
                    Text(Loc.t("flashcards.cardsOnTrack", Leitner.masteredCount(in: srs)))
                        .foregroundStyle(.white)
                }
            }
        }
        .cockpitBackground()
        .navigationTitle(bank.title)
        .task { await loadInitialSRS() }
    }

    private var card: Question? {
        deck.indices.contains(index) ? deck[index] : nil
    }

    private func loadInitialSRS() async {
        if let store, let entries = try? await store.srsEntries(bankID: bank.id) {
            srs = entries
        }
        // Unseen cards are always due, so a fresh deck (no store, or no history
        // yet) still surfaces every card — this only narrows the deck once SRS
        // history exists.
        let due = Set(
            Leitner.dueKeys(in: srs, allKeys: bank.questions.map(\.legacyKey), now: Date()))
        deck = bank.questions.filter { due.contains($0.legacyKey) }
    }

    private func grade(question: Question, correct: Bool) {
        // Instant local feedback for the mastery count, even if persistence is off.
        srs[question.legacyKey] = Leitner.schedule(
            srs[question.legacyKey], correct: correct, now: Date())
        index += 1
        guard let store else { return }
        Task {
            _ = try? await store.grade(question: question, correct: correct)
            _ = try? await store.touchStreak()
        }
    }
}
