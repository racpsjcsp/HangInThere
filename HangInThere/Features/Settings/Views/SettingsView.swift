//
//  SettingsView.swift
//  HangInThere
//
//  Created by Codex on 16/03/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: HangmanGameViewModel
    let onClose: () -> Void

    var body: some View {
        let state = viewModel.settingsMenuViewState

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    header(state: state)
                    progressCard(state: state)
                    togglesCard(state: state)
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

    private func togglesCard(state: SettingsMenuViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                toggleRow(
                    title: Strings.Settings.soundEffects,
                    systemImage: Strings.Symbol.settingsSound,
                    isOn: state.soundEnabled,
                    accessibilityIdentifier: AccessibilityID.Settings.soundToggle,
                    action: viewModel.toggleSound
                )

                Divider()
                    .overlay(AppTheme.panelBorder)

                toggleRow(
                    title: Strings.Settings.haptics,
                    systemImage: Strings.Symbol.settingsHaptics,
                    isOn: state.hapticsEnabled,
                    accessibilityIdentifier: AccessibilityID.Settings.hapticsToggle,
                    action: viewModel.toggleHaptics
                )
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

    private func toggleRow(
        title: String,
        systemImage: String,
        isOn: Bool,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: systemImage)
                .foregroundStyle(AppTheme.primary)
                .frame(width: 22)

            Text(title)
                .font(AppTheme.Typography.section())
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()

            Toggle("", isOn: Binding(
                get: { isOn },
                set: { _ in action() }
            ))
            .labelsHidden()
            .tint(AppTheme.secondary)
            .accessibilityIdentifier(accessibilityIdentifier)
        }
    }
}

#Preview {
    SettingsView(viewModel: HangmanGameViewModel(), onClose: {})
}
