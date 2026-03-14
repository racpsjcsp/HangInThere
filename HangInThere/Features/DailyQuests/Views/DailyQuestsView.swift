//
//  DailyQuestsView.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import SwiftUI

struct DailyQuestsView: View {
    @ObservedObject var viewModel: HangmanGameViewModel
    let onClose: () -> Void

    var body: some View {
        let state = viewModel.dailyQuestMenuViewState

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    header(state: state)

                    if let sundayBonusText = state.sundayBonusText {
                        AppCard {
                            HStack(spacing: AppTheme.Spacing.small) {
                                Image(systemName: Strings.Symbol.dailyQuestsSundayBonus)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(AppTheme.warning)

                                Text(sundayBonusText)
                                    .font(AppTheme.Typography.body())
                                    .foregroundStyle(AppTheme.textPrimary)
                            }
                        }
                    }

                    ForEach(state.quests) { quest in
                        questCard(quest)
                    }

                    bonusCard(state.bonus)
                }
                .padding(AppTheme.Spacing.large)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(state.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Strings.DailyQuests.close, action: onClose)
                }
            }
            .accessibilityIdentifier(AccessibilityID.DailyQuests.title)
        }
    }

    private func header(state: DailyQuestMenuViewState) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(state.subtitle)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private func questCard(_ quest: DailyQuestItemViewState) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack(alignment: .top, spacing: AppTheme.Spacing.small) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                        Text(quest.title)
                            .font(AppTheme.Typography.section())
                            .foregroundStyle(AppTheme.textPrimary)

                        Text(quest.progressText)
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    Spacer()

                    AppPill(
                        text: quest.rewardText,
                        color: quest.isClaimed ? AppTheme.secondary.opacity(0.7) : AppTheme.primary
                    )
                }

                if quest.isClaimed {
                    Text(Strings.DailyQuests.claimed)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.success)
                } else {
                    AppButton(
                        title: quest.isCompleted ? Strings.DailyQuests.claimReward : Strings.DailyQuests.inProgress,
                        systemImage: quest.isCompleted ? "checkmark.circle.fill" : "clock.fill",
                        style: quest.isCompleted ? .secondary : .ghost,
                        layout: .horizontal,
                        size: .compact,
                        accessibilityIdentifier: AccessibilityID.DailyQuests.claimButton(quest.kind)
                    ) {
                        viewModel.claimDailyQuest(quest.kind)
                    }
                    .disabled(!quest.isCompleted)
                }
            }
        }
    }

    private func bonusCard(_ bonus: DailyQuestBonusViewState) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack(spacing: AppTheme.Spacing.small) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                        Text(bonus.title)
                            .font(AppTheme.Typography.section())
                            .foregroundStyle(AppTheme.textPrimary)

                        Text(bonus.subtitle)
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    Spacer()

                    AppPill(text: bonus.rewardText, color: AppTheme.warning)
                }

                if bonus.isClaimed {
                    Text(Strings.DailyQuests.claimed)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.success)
                } else {
                    AppButton(
                        title: bonus.isUnlocked ? Strings.DailyQuests.claimReward : Strings.DailyQuests.completeAllFirst,
                        systemImage: bonus.isUnlocked ? "star.circle.fill" : "lock.fill",
                        style: bonus.isUnlocked ? .primary : .ghost,
                        layout: .horizontal,
                        size: .compact,
                        accessibilityIdentifier: AccessibilityID.DailyQuests.claimCompletionBonusButton
                    ) {
                        viewModel.claimDailyQuestCompletionBonus()
                    }
                    .disabled(!bonus.isUnlocked)
                }
            }
        }
    }
}

#Preview {
    DailyQuestsView(viewModel: HangmanGameViewModel(), onClose: {})
}
