//
//  CategorySelectionView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: HangmanGameViewModel
    let onChooseCategory: (HangmanCategory) -> Void
    let onOpenDailyQuests: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        let state = viewModel.categorySelectionViewState

        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                header(state: state)
                progressCard(state: state)

                LazyVGrid(columns: columns, spacing: AppTheme.Spacing.small) {
                    ForEach(state.categories) { category in
                        Button {
                            onChooseCategory(category.category)
                        } label: {
                            AppCard {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                                    HStack {
                                        Image(category.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 42, height: 42)
                                        Spacer()
                                    }
                                    .frame(height: 42)

                                    Text(category.title)
                                        .font(AppTheme.Typography.section())
                                        .foregroundStyle(AppTheme.textPrimary)

                                    Text(category.description)
                                        .font(AppTheme.Typography.caption())
                                        .foregroundStyle(AppTheme.textSecondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .frame(maxWidth: .infinity, minHeight: 34, alignment: .topLeading)

                                    Spacer(minLength: 0)
                                }
                                .frame(maxWidth: .infinity, minHeight: 148, maxHeight: 148, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier(AccessibilityID.CategorySelection.categoryButton(category.category))
                    }
                }
            }
            .padding(AppTheme.Spacing.large)
        }
    }

    private func header(state: CategorySelectionViewState) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(state.title)
                .font(AppTheme.Typography.title())
                .foregroundStyle(AppTheme.textPrimary)
                .accessibilityIdentifier(AccessibilityID.CategorySelection.title)
            Text(state.message)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private func progressCard(state: CategorySelectionViewState) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack {
                    Text(state.progressTitle)
                        .font(AppTheme.Typography.section())
                        .foregroundStyle(AppTheme.textPrimary)

                    Spacer()

                    AppPill(text: state.levelText, color: AppTheme.primary)
                }

                AppProgressBar(progress: state.progressValue, fill: AppTheme.secondary)
                    .frame(height: 10)

                HStack(spacing: AppTheme.Spacing.small) {
                    AppStatBadge(title: state.revealTitle, value: state.revealValue)
                    AppStatBadge(title: state.freeGuessTitle, value: state.freeGuessValue)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    HStack {
                        Text(state.dailyQuestsTitle)
                            .font(AppTheme.Typography.section())
                            .foregroundStyle(AppTheme.textPrimary)

                        Spacer()

                        Text(state.dailyQuestsSummary)
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    AppButton(
                        title: state.dailyQuestsButtonTitle,
                        systemImage: Strings.Symbol.dailyQuestsButton,
                        style: .ghost,
                        layout: .horizontal,
                        size: .compact,
                        accessibilityIdentifier: AccessibilityID.CategorySelection.dailyQuestsButton,
                        action: onOpenDailyQuests
                    )
                }
            }
        }
    }
}

#Preview {
    CategorySelectionView(viewModel: HangmanGameViewModel(), onChooseCategory: { _ in }, onOpenDailyQuests: {})
}
