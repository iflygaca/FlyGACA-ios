import PersistenceKit
import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    public let store: StudyStore?

    @AppStorage("flygaca.hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("flygaca.soundEnabled") private var soundEnabled = true
    @State private var showingResetAlert = false
    @State private var resetSuccess = false

    public init(store: StudyStore? = nil) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section(Loc.t("settings.general")) {
                    Toggle(Loc.t("settings.haptics"), isOn: $hapticsEnabled)
                        .tint(FGTheme.teal)

                    Toggle(Loc.t("settings.sound"), isOn: $soundEnabled)
                        .tint(FGTheme.teal)

                    HStack {
                        Text(Loc.t("settings.language"))
                        Spacer()
                        Text(Locale.current.language.languageCode?.identifier == "ar" ? "العربية" : "English")
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(FGTheme.deep)

                Section(Loc.t("settings.about")) {
                    HStack {
                        Text(Loc.t("settings.version"))
                        Spacer()
                        Text("1.0.0 (Build 1)")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text(Loc.t("settings.appID"))
                        Spacer()
                        Text("com.flygaca.app")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Offline Readiness")
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(FGTheme.sage)
                            Text("100% Offline")
                                .font(.caption.bold())
                                .foregroundStyle(FGTheme.sage)
                        }
                    }
                }
                .listRowBackground(FGTheme.deep)

                Section {
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text(Loc.t("settings.resetProgress"))
                        }
                        .foregroundStyle(FGTheme.clay)
                    }
                    .alert(Loc.t("settings.resetProgress"), isPresented: $showingResetAlert) {
                        Button(Loc.t("settings.resetConfirm"), role: .destructive) {
                            if let store {
                                Task {
                                    try? await store.resetAllProgress()
                                    await MainActor.run {
                                        resetSuccess = true
                                        HapticFeedback.success()
                                    }
                                }
                            } else {
                                resetSuccess = true
                            }
                        }
                        Button(Loc.t("settings.cancel"), role: .cancel) {}
                    } message: {
                        Text(Loc.t("settings.resetWarning"))
                    }
                }
                .listRowBackground(FGTheme.deep)

                Section {
                    Disclaimer()
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(FGTheme.night)
            .navigationTitle(Loc.t("settings.title"))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(FGTheme.gold)
                }
            }
        }
    }
}
