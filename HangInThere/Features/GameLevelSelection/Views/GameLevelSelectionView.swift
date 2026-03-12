//
//  GameLevelSelectionView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct GameLevelSelectionView: View {
    @ObservedObject var viewModel: HangmanGameViewModel
    let onChooseLevel: (GameLevel) -> Void
    let onGoBack: () -> Void

    var body: some View {
        if let state = viewModel.levelSelectionViewState {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    header(state: state)
                    levelCards(state: state)

                    AppButton(
                        title: state.backButtonTitle,
                        systemImage: "arrow.left.circle",
                        style: .ghost,
                        accessibilityIdentifier: AccessibilityID.LevelSelection.backButton,
                        action: onGoBack
                    )
                }
                .padding(AppTheme.Spacing.large)
            }
        }
    }

    private func header(state: GameLevelSelectionViewState) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(state.title)
                .font(AppTheme.Typography.title())
                .foregroundStyle(AppTheme.textPrimary)
                .accessibilityIdentifier(AccessibilityID.LevelSelection.title)

            Text(state.subtitle)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.textSecondary)

            AppPill(text: state.categoryTitle, color: state.categoryTint)
        }
    }

    private func levelCards(state: GameLevelSelectionViewState) -> some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ForEach(state.levels) { level in
                Button {
                    onChooseLevel(level.level)
                } label: {
                    AppCard {
                        HStack(spacing: AppTheme.Spacing.medium) {
                            Image(systemName: level.symbol)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(level.tint)
                                .frame(width: 34)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                                Text(level.title)
                                    .font(AppTheme.Typography.section())
                                    .foregroundStyle(AppTheme.textPrimary)

                                Text(level.description)
                                    .font(AppTheme.Typography.body())
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(AccessibilityID.LevelSelection.levelButton(level.level))
            }
        }
    }
}

#Preview {
    GameLevelSelectionView(
        viewModel: HangmanGameViewModel(),
        onChooseLevel: { _ in },
        onGoBack: {}
    )
}
