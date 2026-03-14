//
//  SplashScreenView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct SplashScreenView: View {
    private static let backgroundOverlayBottomColor = Color(red: 0.06, green: 0.11, blue: 0.18)
    private static let splashTextPrimary = Color.black.opacity(0.82)
    private static let splashTextSecondary = Color.black.opacity(0.68)

    let onStart: () -> Void

    var body: some View {
        content
            .background(backgroundLayer)
    }

    private var backgroundLayer: some View {
        Image(Strings.Asset.splashBackground)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(backgroundOverlay)
    }

    private var backgroundOverlay: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.18),
                Color.white.opacity(0.08),
                Self.backgroundOverlayBottomColor.opacity(0.72)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var content: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()
            heroSection
            featuresCard
            startButton
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.xLarge)
    }

    private var heroSection: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            Image(Strings.Asset.splashEmblem)
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 74)

            AppPill(text: Strings.Splash.badge, color: AppTheme.secondary)

            Image(Strings.Asset.splashLogo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 320)
                .accessibilityIdentifier(AccessibilityID.Splash.title)

            Text(Strings.Splash.subtitle)
                .font(AppTheme.Typography.body())
                .foregroundStyle(Self.splashTextPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.large)
        }
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(Strings.Splash.featuresTitle)
                .font(AppTheme.Typography.section())
                .foregroundStyle(Self.splashTextPrimary)

            featureRow(symbol: Strings.Symbol.splashCategoriesFeature, text: Strings.Splash.categoriesFeature)
            featureRow(symbol: Strings.Symbol.splashProgressionFeature, text: Strings.Splash.progressionFeature)
            featureRow(symbol: Strings.Symbol.splashPowersFeature, text: Strings.Splash.powersFeature)
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            Color.white.opacity(0.72),
            in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous)
                .stroke(Color.white.opacity(0.48), lineWidth: 1)
        }
        .shadow(color: AppTheme.Shadow.card, radius: 18, y: 12)
        .padding(.horizontal, AppTheme.Spacing.large)
    }

    private var startButton: some View {
        AppButton(
            title: Strings.Splash.start,
            systemImage: Strings.Symbol.startButton,
            style: .primary,
            layout: .horizontal,
            accessibilityIdentifier: AccessibilityID.Splash.startButton,
            action: onStart
        )
        .padding(.horizontal, AppTheme.Spacing.large)
    }

    private func featureRow(symbol: String, text: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xSmall) {
            Image(systemName: symbol)
                .foregroundStyle(AppTheme.primary)
            Text(text)
                .font(AppTheme.Typography.body())
                .foregroundStyle(Self.splashTextSecondary)
        }
    }
}

#Preview {
    SplashScreenView(onStart: {})
}
