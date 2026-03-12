//
//  SplashScreenView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct SplashScreenView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            VStack(spacing: AppTheme.Spacing.small) {
                AppPill(text: Strings.Splash.badge, color: AppTheme.secondary)

                Text(Strings.Splash.title)
                    .font(AppTheme.Typography.hero())
                    .foregroundStyle(AppTheme.textPrimary)
                    .accessibilityIdentifier(AccessibilityID.Splash.title)

                Text(Strings.Splash.subtitle)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text(Strings.Splash.featuresTitle)
                        .font(AppTheme.Typography.section())
                        .foregroundStyle(AppTheme.textPrimary)

                    featureRow(symbol: Strings.Symbol.splashCategoriesFeature, text: Strings.Splash.categoriesFeature)
                    featureRow(symbol: Strings.Symbol.splashProgressionFeature, text: Strings.Splash.progressionFeature)
                    featureRow(symbol: Strings.Symbol.splashPowersFeature, text: Strings.Splash.powersFeature)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.large)

            AppButton(
                title: Strings.Splash.start,
                systemImage: Strings.Symbol.startButton,
                style: .primary,
                layout: .horizontal,
                accessibilityIdentifier: AccessibilityID.Splash.startButton,
                action: onStart
            )
            .padding(.horizontal, AppTheme.Spacing.large)

            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.xLarge)
    }

    private func featureRow(symbol: String, text: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xSmall) {
            Image(systemName: symbol)
                .foregroundStyle(AppTheme.primary)
            Text(text)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.textSecondary)
        }
    }
}

#Preview {
    SplashScreenView(onStart: {})
}
