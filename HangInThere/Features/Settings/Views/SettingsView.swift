//
//  SettingsView.swift
//  HangInThere
//
//  Created by Codex on 16/03/26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: HangmanGameViewModel
    let onClose: () -> Void
    @State private var feedbackTrigger = 0

    var body: some View {
        let state = viewModel.settingsMenuViewState

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    header(state: state)
                    progressCard(state: state)
                    togglesCard
                    storageCard(state: state)
                }
                .padding(AppTheme.Spacing.large)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(state.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Strings.Settings.done, action: onClose)
                        .accessibilityIdentifier(AccessibilityID.Settings.doneButton)
                }
            }
            .accessibilityIdentifier(AccessibilityID.Settings.title)
        }
        .sensoryFeedback(.selection, trigger: feedbackTrigger)
        .onChange(of: viewModel.soundEnabled) { _, _ in
            guard viewModel.hapticsEnabled else { return }
            feedbackTrigger += 1
        }
        .onChange(of: viewModel.hapticsEnabled) { _, newValue in
            guard newValue else { return }
            feedbackTrigger += 1
        }
    }

    private func header(state: SettingsMenuViewState) -> some View {
        Text(state.subtitle)
            .font(AppTheme.Typography.body())
            .foregroundStyle(AppTheme.textSecondary)
    }

    private func progressCard(state: SettingsMenuViewState) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack {
                    Text(Strings.Selection.progressTitle)
                        .font(AppTheme.Typography.section())
                        .foregroundStyle(AppTheme.textPrimary)

                    Spacer()

                    AppPill(text: state.playerLevelText, color: AppTheme.primary)
                }

                Text(state.progressText)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.textSecondary)

                Text(state.nextRewardText)
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
    }

    private var togglesCard: some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                Toggle(isOn: $viewModel.soundEnabled) {
                    toggleRowLabel(
                        title: Strings.Settings.soundEffects,
                        systemImage: Strings.Symbol.settingsSound
                    )
                }
                .tint(AppTheme.secondary)
                .accessibilityIdentifier(AccessibilityID.Settings.soundToggle)

                Divider()
                    .overlay(AppTheme.panelBorder)

                Toggle(isOn: $viewModel.hapticsEnabled) {
                    toggleRowLabel(
                        title: Strings.Settings.haptics,
                        systemImage: Strings.Symbol.settingsHaptics
                    )
                }
                .tint(AppTheme.secondary)
                .accessibilityIdentifier(AccessibilityID.Settings.hapticsToggle)
            }
        }
    }

    private func storageCard(state: SettingsMenuViewState) -> some View {
        AppCard {
            Text(state.storageNote)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private func toggleRowLabel(
        title: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: systemImage)
                .foregroundStyle(AppTheme.primary)
                .frame(width: 22)

            Text(title)
                .font(AppTheme.Typography.section())
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()
        }
    }
}

#Preview {
    SettingsView(viewModel: HangmanGameViewModel(), onClose: {})
}
