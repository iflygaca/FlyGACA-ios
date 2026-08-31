import SwiftUI

/// One flip card + grade buttons. Grading semantics (Leitner boxes, due dates)
/// live in StudyEngines/PersistenceKit — this view only reports correct/wrong.
public struct FlashcardView: View {
    public let front: String
    public let back: String
    public let onGrade: (Bool) -> Void

    @State private var flipAngle: Double = 0.0
    @State private var dragOffset: CGSize = .zero

    public init(front: String, back: String, onGrade: @escaping (Bool) -> Void) {
        self.front = front
        self.back = back
        self.onGrade = onGrade
    }

    private var isRevealed: Bool {
        flipAngle >= 90
    }

    public var body: some View {
        VStack(spacing: 20) {
            // 3D Flip Card
            ZStack {
                // Back Face (Answer)
                if isRevealed {
                    VStack(spacing: 12) {
                        HStack {
                            Text("ANSWER & EXPLANATION")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(FGTheme.teal)
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(FGTheme.teal)
                        }

                        Spacer()

                        Text(back)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer()
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 260)
                    .background(FGTheme.deep)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(FGTheme.teal.opacity(0.4), lineWidth: 1.5)
                    )
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    // Front Face (Prompt)
                    VStack(spacing: 12) {
                        HStack {
                            Text("QUESTION PROMPT")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(FGTheme.gold)
                            Spacer()
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundStyle(FGTheme.gold)
                        }

                        Spacer()

                        Text(front)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "hand.tap.fill")
                            Text(Loc.t("flashcard.tapToReveal"))
                        }
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 260)
                    .background(FGTheme.deep)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(FGTheme.gold.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .rotation3DEffect(
                .degrees(flipAngle),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.6
            )
            .offset(dragOffset)
            .rotationEffect(.degrees(Double(dragOffset.width / 20.0)))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        if value.translation.width > 100 {
                            grade(true)
                        } else if value.translation.width < -100 {
                            grade(false)
                        } else {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            .onTapGesture {
                HapticFeedback.light()
                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                    flipAngle = (flipAngle == 0 ? 180 : 0)
                }
            }
            .accessibilityAddTraits(.isButton)

            // Bottom Action Controls
            if isRevealed {
                HStack(spacing: 16) {
                    Button {
                        grade(false)
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text(Loc.t("flashcard.again"))
                        }
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(FGTheme.clay.opacity(0.15))
                        .foregroundStyle(FGTheme.clay)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(FGTheme.clay, lineWidth: 1))
                    }

                    Button {
                        grade(true)
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(Loc.t("flashcard.gotIt"))
                        }
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(FGTheme.teal)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else {
                Text("Swipe right for Got It, left for Again, or tap to flip")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    private func grade(_ correct: Bool) {
        if correct {
            HapticFeedback.success()
        } else {
            HapticFeedback.warning()
        }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            flipAngle = 0
            dragOffset = .zero
        }
        onGrade(correct)
    }
}
