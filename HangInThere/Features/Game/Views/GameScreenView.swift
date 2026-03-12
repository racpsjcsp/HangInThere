//
//  GameScreenView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct GameScreenView: View {
    @ObservedObject var viewModel: HangmanGameViewModel
    let onGoToCategories: () -> Void
    let onContinueAfterRound: () -> Void

    var body: some View {
        if let state = viewModel.gameViewState {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.large) {
                    topBar(state: state)
                    puzzleCard(state: state)
                    powersCard(state: state)
                    keyboard(state: state)

                    if let summary = state.summary {
                        summaryCard(summary: summary)
                    }
                }
                .padding(AppTheme.Spacing.large)
            }
        }
    }

    private func topBar(state: GameViewState) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            AppPill(text: state.categoryTitle, color: state.categoryTint)
                .accessibilityIdentifier(AccessibilityID.Game.categoryTitle)
            difficultyBadge(state: state)
            Spacer()
            AppButton(
                title: state.categoriesButtonTitle,
                systemImage: Strings.Symbol.categoriesButton,
                style: .ghost,
                accessibilityIdentifier: AccessibilityID.Game.categoriesButton,
                action: onGoToCategories
            )
            .frame(maxWidth: 150)
        }
    }

    private func difficultyBadge(state: GameViewState) -> some View {
        HStack(spacing: AppTheme.Spacing.xxxSmall) {
            Image(systemName: state.gameLevelSymbol)
            Text(state.gameLevelTitle)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(state.gameLevelTitle)
        .font(AppTheme.Typography.caption())
        .foregroundStyle(Color.black.opacity(0.78))
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xxSmall)
        .background(state.gameLevelTint, in: Capsule())
        .accessibilityIdentifier(AccessibilityID.Game.modeBadge)
    }

    private func puzzleCard(state: GameViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(state.playerLevelText)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.textMuted)

                    Text(state.face)
                        .font(.system(size: 54))

                    Text(state.maskedAnswer)
                        .font(AppTheme.Typography.letter())
                        .kerning(1.4)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppTheme.textPrimary)
                        .accessibilityIdentifier(AccessibilityID.Game.maskedAnswer)
                }

                VStack(spacing: AppTheme.Spacing.xxxSmall) {
                    Text(state.hintTitle)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.textMuted)
                    Text(state.hintText)
                        .font(AppTheme.Typography.body())
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier(AccessibilityID.Game.hintText)
                }

                HStack(spacing: AppTheme.Spacing.small) {
                    AppStatBadge(title: state.livesTitle, value: state.livesValue)
                    AppStatBadge(title: state.wrongTitle, value: state.wrongValue)
                }

                if state.showFreeGuessActive {
                    AppPill(text: state.freeGuessActiveText, color: AppTheme.secondary)
                }

                Text(state.message)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func powersCard(state: GameViewState) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text(Strings.Game.powersTitle)
                    .font(AppTheme.Typography.section())
                    .foregroundStyle(AppTheme.textPrimary)

                HStack(spacing: AppTheme.Spacing.small) {
                    AppButton(
                        title: state.revealButtonTitle,
                        systemImage: state.revealButtonSymbol,
                        style: .secondary,
                        accessibilityIdentifier: AccessibilityID.Game.revealButton
                    ) {
                        viewModel.usePower(.revealLetter)
                    }

                    AppButton(
                        title: state.freeGuessButtonTitle,
                        systemImage: state.freeGuessButtonSymbol,
                        style: .ghost,
                        accessibilityIdentifier: AccessibilityID.Game.freeGuessButton
                    ) {
                        viewModel.usePower(.freeGuess)
                    }
                }
            }
        }
    }

    private func keyboard(state: GameViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(state.keyboardRows.indices, id: \.self) { rowIndex in
                    HStack(spacing: AppTheme.Spacing.xxxSmall) {
                        ForEach(state.keyboardRows[rowIndex], id: \.self) { letter in
                            let wasGuessed = state.guessedLetters.contains(letter)
                            Button {
                                viewModel.guess(letter)
                            } label: {
                                Text(letter)
                                    .font(AppTheme.Typography.body())
                                    .foregroundStyle(wasGuessed ? AppTheme.textMuted : AppTheme.textPrimary)
                                    .frame(maxWidth: .infinity, minHeight: 42)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(wasGuessed ? Color.white.opacity(0.06) : Color.white.opacity(0.12))
                                    )
                            }
                            .buttonStyle(.plain)
                            .disabled(wasGuessed || !state.isPlaying)
                            .accessibilityIdentifier(AccessibilityID.Game.keyboardButton(letter))
                        }
                    }
                }
            }
        }
    }

    private func summaryCard(summary: SummaryViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.small) {
                Text(summary.title)
                    .font(AppTheme.Typography.title())
                    .foregroundStyle(AppTheme.textPrimary)
                    .accessibilityIdentifier(AccessibilityID.Game.summaryTitle)

                Text(summary.subtitle)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.textSecondary)

                HStack(spacing: AppTheme.Spacing.small) {
                    AppButton(
                        title: Strings.Game.nextRound,
                        systemImage: Strings.Symbol.nextRoundButton,
                        style: .primary,
                        accessibilityIdentifier: AccessibilityID.Game.nextRoundButton,
                        action: onContinueAfterRound
                    )

                    AppButton(
                        title: Strings.Game.changeCategory,
                        systemImage: Strings.Symbol.changeCategoryButton,
                        style: .ghost,
                        accessibilityIdentifier: AccessibilityID.Game.changeCategoryButton,
                        action: onGoToCategories
                    )
                }
            }
        }
    }
}

#Preview {
    let viewModel = HangmanGameViewModel()
    viewModel.showCategorySelection(message: Strings.Message.start)
    viewModel.startRound(for: .animals, level: .medium)
    return GameScreenView(viewModel: viewModel, onGoToCategories: {}, onContinueAfterRound: {})
}
