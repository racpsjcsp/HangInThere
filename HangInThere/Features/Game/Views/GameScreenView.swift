//
//  GameScreenView.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct GameScreenView: View {
    private struct PuzzleLayoutMetrics {
        let hangmanHeight: CGFloat
        let hangmanHorizontalPadding: CGFloat
        let sideColumnWidth: CGFloat
        let sideColumnSpacing: CGFloat
        let statBadgeVerticalPadding: CGFloat
        let powerLabelWidth: CGFloat
        let powerLabelToIconOffset: CGFloat
        let powerIconSize: CGFloat
        let powerRingSize: CGFloat
    }

    @ObservedObject var viewModel: HangmanGameViewModel
    let onGoToCategories: () -> Void
    let onContinueAfterRound: () -> Void
    @State private var correctPulse = false
    @State private var wrongFlash = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var showWinCelebration = false
    @State private var roundRefreshPulse = false
    @State private var revealPowerFlash = false
    @State private var freeGuessPowerFlash = false

    var body: some View {
        if let state = viewModel.gameViewState {
            GeometryReader { proxy in
                let horizontalInset = horizontalPadding(for: proxy.size.width)
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.large) {
                        topBar(state: state)
                        puzzleCard(
                            state: state,
                            contentWidth: max(0, proxy.size.width - (horizontalInset * 2))
                        )
                        if let summary = state.summary {
                            summaryCard(summary: summary)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .scale(scale: 0.96)).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            keyboard(state: state)
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                        }
                    }
                    .frame(width: max(0, proxy.size.width - (horizontalInset * 2)), alignment: .top)
                    .padding(.horizontal, horizontalInset)
                    .padding(.vertical, AppTheme.Spacing.large)
                }
            }
            .animation(AppTheme.Motion.summaryReveal, value: state.summary?.title)
            .onChange(of: state.maskedAnswer) { oldValue, newValue in
                guard oldValue != newValue, state.isPlaying else { return }
                guard revealedCharacterCount(in: newValue) > revealedCharacterCount(in: oldValue) else { return }
                triggerCorrectFeedback()
            }
            .onChange(of: state.wrongGuessCount) { oldValue, newValue in
                guard oldValue != newValue, state.isPlaying else { return }
                guard !(oldValue > 0 && newValue == 0) else { return }
                triggerWrongFeedback()
            }
            .onChange(of: state.summary?.title) { oldValue, newValue in
                if oldValue != nil, newValue == nil, state.isPlaying {
                    triggerRoundRefreshFeedback()
                }
                triggerWinCelebrationIfNeeded(for: state.summary)
            }
            .onChange(of: state.revealPowerCharges) { oldValue, newValue in
                guard newValue < oldValue else { return }
                triggerPowerFeedback(for: .revealLetter)
            }
            .onChange(of: state.freeGuessPowerCharges) { oldValue, newValue in
                guard newValue < oldValue else { return }
                triggerPowerFeedback(for: .freeGuess)
            }
            .onAppear {
                triggerWinCelebrationIfNeeded(for: state.summary)
            }
        }
    }

    private func horizontalPadding(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<390:
            AppTheme.Spacing.small
        case ..<430:
            AppTheme.Spacing.medium
        default:
            AppTheme.Spacing.large
        }
    }

    private func topBar(state: GameViewState) -> some View {
        compactTopBar(state: state)
    }

    private func compactTopBar(state: GameViewState) -> some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            HStack(spacing: AppTheme.Spacing.xSmall) {
                compactPill(text: state.categoryTitle, color: state.categoryTint)
                    .accessibilityIdentifier(AccessibilityID.Game.categoryTitle)
                difficultyBadge(state: state)
            }
            .fixedSize(horizontal: true, vertical: false)

            Spacer(minLength: AppTheme.Spacing.xxxSmall)

            categoriesButton(state: state)
                .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func categoriesButton(state: GameViewState) -> some View {
        AppButton(
            title: state.categoriesButtonTitle,
            systemImage: Strings.Symbol.categoriesButton,
            style: .ghost,
            layout: .horizontal,
            accessibilityIdentifier: AccessibilityID.Game.categoriesButton,
            action: onGoToCategories
        )
        .fixedSize(horizontal: true, vertical: false)
    }

    private var soundToggleButton: some View {
        Button {
            viewModel.toggleSound()
        } label: {
            Image(systemName: viewModel.isSoundEnabled ? Strings.Symbol.soundOn : Strings.Symbol.soundOff)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.textPrimary)
                .frame(width: 36, height: 36)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous)
                        .stroke(AppTheme.panelBorder, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(viewModel.isSoundEnabled ? Strings.Game.soundOn : Strings.Game.soundOff)
        .accessibilityIdentifier(AccessibilityID.Game.soundToggleButton)
        .fixedSize()
    }

    private func difficultyBadge(state: GameViewState) -> some View {
        HStack(spacing: AppTheme.Spacing.xxxSmall) {
            Text(state.gameLevelTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(state.gameLevelTitle)
        .font(AppTheme.Typography.caption())
        .foregroundStyle(Color.black.opacity(0.78))
        .padding(.horizontal, AppTheme.Spacing.xxxSmall)
        .padding(.vertical, 5)
        .background(state.gameLevelTint, in: Capsule())
        .accessibilityIdentifier(AccessibilityID.Game.modeBadge)
        .fixedSize(horizontal: true, vertical: false)
    }

    private func compactPill(text: String, color: Color) -> some View {
        Text(text)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
        .font(AppTheme.Typography.caption())
        .foregroundStyle(Color.black.opacity(0.78))
        .padding(.horizontal, AppTheme.Spacing.xxxSmall)
        .padding(.vertical, 5)
        .background(color, in: Capsule())
        .fixedSize(horizontal: true, vertical: false)
    }

    private func puzzleCard(state: GameViewState, contentWidth: CGFloat) -> some View {
        let metrics = puzzleLayoutMetrics(for: contentWidth)

        return AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(state.playerLevelText)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.textMuted)

                    ZStack {
                        HangmanArtworkView(stage: state.hangmanStage)
                            .frame(height: metrics.hangmanHeight)
                            .padding(.horizontal, metrics.hangmanHorizontalPadding)

                        HStack {
                            statsColumn(state: state, metrics: metrics)

                            Spacer()

                            powerColumn(state: state, metrics: metrics)
                        }
                    }

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

                if state.showFreeGuessActive {
                    AppPill(text: state.freeGuessActiveText, color: AppTheme.secondary)
                }

                Text(state.message)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .overlay(alignment: .topTrailing) {
            soundToggleButton
                .padding(AppTheme.Spacing.small)
        }
        .scaleEffect(correctPulse ? 1.02 : (roundRefreshPulse ? 1.015 : 1))
        .modifier(ShakeEffect(animatableData: shakeTrigger))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous)
                .stroke(
                    wrongFlash
                    ? AppTheme.accent.opacity(0.8)
                    : roundRefreshPulse
                    ? state.gameLevelTint.opacity(0.85)
                    : AppTheme.success.opacity(correctPulse ? 0.75 : 0),
                    lineWidth: 2
                )
        }
        .shadow(
            color: wrongFlash
                ? AppTheme.accent.opacity(0.28)
                : roundRefreshPulse
                ? state.gameLevelTint.opacity(0.28)
                : AppTheme.success.opacity(correctPulse ? 0.25 : 0),
            radius: correctPulse || wrongFlash || roundRefreshPulse ? 18 : 0
        )
    }

    private func statsColumn(state: GameViewState, metrics: PuzzleLayoutMetrics) -> some View {
        VStack(spacing: metrics.sideColumnSpacing) {
            compactGameStatBadge(
                title: state.livesTitle,
                value: state.livesValue,
                metrics: metrics
            )
            compactGameStatBadge(
                title: state.wrongTitle,
                value: state.wrongValue,
                metrics: metrics
            )
        }
    }

    private func powerColumn(state: GameViewState, metrics: PuzzleLayoutMetrics) -> some View {
        VStack(spacing: metrics.sideColumnSpacing) {
            compactPowerButton(
                title: state.revealPowerTitle,
                imageName: state.revealButtonImageName,
                chargeCount: "\(state.revealPowerCharges)",
                isFlashing: revealPowerFlash,
                metrics: metrics,
                accessibilityIdentifier: AccessibilityID.Game.revealButton
            ) {
                viewModel.usePower(.revealLetter)
            }

            compactPowerButton(
                title: state.freeGuessPowerTitle,
                imageName: state.freeGuessButtonImageName,
                chargeCount: "\(state.freeGuessPowerCharges)",
                isFlashing: freeGuessPowerFlash,
                metrics: metrics,
                accessibilityIdentifier: AccessibilityID.Game.freeGuessButton
            ) {
                viewModel.usePower(.freeGuess)
            }
        }
    }

    private func compactGameStatBadge(title: String, value: String, metrics: PuzzleLayoutMetrics) -> some View {
        VStack(alignment: .center, spacing: AppTheme.Spacing.xxxSmall) {
            Text(title.uppercased())
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.textMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(value)
                .font(AppTheme.Typography.section())
                .foregroundStyle(AppTheme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(width: metrics.sideColumnWidth)
        .padding(.vertical, metrics.statBadgeVerticalPadding)
        .background(
            Color.white.opacity(0.06),
            in: RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous)
        )
    }

    private func compactPowerButton(
        title: String,
        imageName: String,
        chargeCount: String,
        isFlashing: Bool,
        metrics: PuzzleLayoutMetrics,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(title)
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: metrics.powerLabelWidth)
                    .padding(.bottom, metrics.powerLabelToIconOffset)

                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.white.opacity(isFlashing ? 0.16 : 0))
                        .frame(width: metrics.powerRingSize, height: metrics.powerRingSize)
                        .overlay {
                            Circle()
                                .stroke(AppTheme.secondary.opacity(isFlashing ? 0.65 : 0), lineWidth: 3)
                        }
                        .shadow(color: AppTheme.secondary.opacity(isFlashing ? 0.45 : 0), radius: isFlashing ? 16 : 0)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: metrics.powerIconSize, height: metrics.powerIconSize)
                        .offset(y: -6)
                        .scaleEffect(isFlashing ? 1.14 : 1)

                    Text(chargeCount)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.42), in: Capsule())
                        .offset(x: 4, y: 4)
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.22), value: isFlashing)
        .accessibilityIdentifier(accessibilityIdentifier)
    }

    private func puzzleLayoutMetrics(for contentWidth: CGFloat) -> PuzzleLayoutMetrics {
        switch contentWidth {
        case ..<340:
            PuzzleLayoutMetrics(
                hangmanHeight: 212,
                hangmanHorizontalPadding: 0,
                sideColumnWidth: 78,
                sideColumnSpacing: AppTheme.Spacing.xSmall,
                statBadgeVerticalPadding: AppTheme.Spacing.xSmall,
                powerLabelWidth: 72,
                powerLabelToIconOffset: -1,
                powerIconSize: 58,
                powerRingSize: 60
            )
        case ..<390:
            PuzzleLayoutMetrics(
                hangmanHeight: 232,
                hangmanHorizontalPadding: 6,
                sideColumnWidth: 84,
                sideColumnSpacing: AppTheme.Spacing.small,
                statBadgeVerticalPadding: AppTheme.Spacing.xSmall,
                powerLabelWidth: 78,
                powerLabelToIconOffset: -1,
                powerIconSize: 64,
                powerRingSize: 66
            )
        default:
            PuzzleLayoutMetrics(
                hangmanHeight: 252,
                hangmanHorizontalPadding: 12,
                sideColumnWidth: 92,
                sideColumnSpacing: AppTheme.Spacing.small,
                statBadgeVerticalPadding: AppTheme.Spacing.small,
                powerLabelWidth: 86,
                powerLabelToIconOffset: 0,
                powerIconSize: 76,
                powerRingSize: 76
            )
        }
    }

    private func triggerPowerFeedback(for power: PowerUp) {
        switch power {
        case .revealLetter:
            revealPowerFlash = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                revealPowerFlash = false
            }
        case .freeGuess:
            freeGuessPowerFlash = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                freeGuessPowerFlash = false
            }
        }
    }

    private func keyboard(state: GameViewState) -> some View {
        AppCard {
            GeometryReader { proxy in
                let columnCount = 10
                let keySpacing = AppTheme.Spacing.xxxSmall
                let rowSpacing = AppTheme.Spacing.small
                let keyHeight: CGFloat = 42
                let totalSpacing = CGFloat(columnCount - 1) * keySpacing
                let keyWidth = (proxy.size.width - totalSpacing) / CGFloat(columnCount)

                VStack(spacing: rowSpacing) {
                    ForEach(state.keyboardRows.indices, id: \.self) { rowIndex in
                        let row = state.keyboardRows[rowIndex]
                        let rowInset = CGFloat(columnCount - row.count) * (keyWidth + keySpacing) / 2

                        HStack(spacing: keySpacing) {
                            ForEach(row, id: \.self) { letter in
                                let wasGuessed = state.guessedLetters.contains(letter)
                                Button {
                                    viewModel.guess(letter)
                                } label: {
                                    Text(letter)
                                        .font(AppTheme.Typography.body())
                                        .foregroundStyle(wasGuessed ? AppTheme.textMuted : AppTheme.textPrimary)
                                        .frame(width: keyWidth, height: keyHeight)
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
                        .padding(.horizontal, rowInset)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(height: 142)
        }
    }

    private func summaryCard(summary: SummaryViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                ZStack {
                    Circle()
                        .fill(summary.tint.opacity(0.24))
                        .frame(width: 84, height: 84)

                    Image(systemName: summary.symbol)
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(summary.tint)
                }
                .padding(.top, AppTheme.Spacing.xxSmall)
                .scaleEffect(showWinCelebration && summary.isWin ? 1.14 : 1)
                .animation(AppTheme.Motion.celebration, value: showWinCelebration)

                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(summary.title)
                        .font(AppTheme.Typography.title())
                        .foregroundStyle(summary.tint)
                        .accessibilityIdentifier(AccessibilityID.Game.summaryTitle)
                        .scaleEffect(showWinCelebration && summary.isWin ? 1.08 : 1)
                        .animation(AppTheme.Motion.celebration, value: showWinCelebration)

                    Text(summary.subtitle)
                        .font(AppTheme.Typography.body())
                        .foregroundStyle(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                }

                if let levelUpTitle = summary.levelUpTitle,
                   let levelUpSubtitle = summary.levelUpSubtitle {
                    rewardBanner(
                        title: levelUpTitle,
                        subtitle: levelUpSubtitle,
                        icon: "arrow.up.circle.fill",
                        gradient: [AppTheme.successSoft.opacity(0.98), AppTheme.secondary.opacity(0.96), AppTheme.success.opacity(0.92)],
                        iconColor: AppTheme.successDeep,
                        borderColor: AppTheme.successDeep.opacity(0.28)
                    )
                }

                if let powerRewardTitle = summary.powerRewardTitle,
                   let powerRewardSubtitle = summary.powerRewardSubtitle {
                    rewardBanner(
                        title: powerRewardTitle,
                        subtitle: powerRewardSubtitle,
                        icon: "sparkles",
                        gradient: [AppTheme.powerPurple.opacity(0.92), AppTheme.powerBlue.opacity(0.94), AppTheme.secondary.opacity(0.92)],
                        iconColor: Color.white,
                        borderColor: Color.white.opacity(0.28),
                        textColor: Color.white.opacity(0.94),
                        captionColor: Color.white.opacity(0.78)
                    )
                }

                VStack(spacing: AppTheme.Spacing.small) {
                    AppButton(
                        title: Strings.Game.nextRound,
                        systemImage: Strings.Symbol.nextRoundButton,
                        style: summary.isWin ? .primary : .secondary,
                        layout: .horizontal,
                        accessibilityIdentifier: AccessibilityID.Game.nextRoundButton,
                        action: onContinueAfterRound
                    )

                    AppButton(
                        title: Strings.Game.changeCategory,
                        systemImage: Strings.Symbol.changeCategoryButton,
                        style: .ghost,
                        layout: .horizontal,
                        accessibilityIdentifier: AccessibilityID.Game.changeCategoryButton,
                        action: onGoToCategories
                    )
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(summary.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous))
        .overlay(alignment: .top) {
            if summary.isWin {
                WinCelebrationView(isActive: showWinCelebration)
                    .allowsHitTesting(false)
            }
        }
    }

    private func rewardBanner(
        title: String,
        subtitle: String,
        icon: String,
        gradient: [Color],
        iconColor: Color,
        borderColor: Color,
        textColor: Color = Color.black.opacity(0.82),
        captionColor: Color = Color.black.opacity(0.66)
    ) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text(title.uppercased())
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(captionColor)

                Text(subtitle)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(textColor)
            }

            Spacer()
        }
        .padding(AppTheme.Spacing.small)
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        }
    }

    private func triggerCorrectFeedback() {
        withAnimation(AppTheme.Motion.feedbackPulse) {
            correctPulse = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            withAnimation(AppTheme.Motion.feedbackPulse) {
                correctPulse = false
            }
        }
    }

    private func triggerWrongFeedback() {
        withAnimation(AppTheme.Motion.shake) {
            shakeTrigger += 1
        }

        withAnimation(.easeOut(duration: 0.18)) {
            wrongFlash = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            withAnimation(.easeOut(duration: 0.18)) {
                wrongFlash = false
            }
        }
    }

    private func triggerRoundRefreshFeedback() {
        withAnimation(.easeOut(duration: 0.22)) {
            roundRefreshPulse = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            withAnimation(.easeOut(duration: 0.22)) {
                roundRefreshPulse = false
            }
        }
    }

    private func triggerWinCelebrationIfNeeded(for summary: SummaryViewState?) {
        guard let summary else {
            showWinCelebration = false
            return
        }

        guard summary.isWin else {
            showWinCelebration = false
            return
        }

        showWinCelebration = false
        DispatchQueue.main.async {
            withAnimation(AppTheme.Motion.celebration) {
                showWinCelebration = true
            }
        }
    }

    private func revealedCharacterCount(in maskedAnswer: String) -> Int {
        maskedAnswer.reduce(into: 0) { count, character in
            if character != Character(Strings.Game.maskedLetter) && character != Character(Strings.Game.blankCharacter) {
                count += 1
            }
        }
    }
}

private struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                y: 0
            )
        )
    }
}

private struct HangmanArtworkView: View {
    let stage: Int

    var body: some View {
        ZStack {
            hangmanPart(Strings.Asset.hangmanGallows)

            if stage > 0 {
                hangmanPart(Strings.Asset.hangmanHead)
            }

            if stage > 1 {
                hangmanPart(Strings.Asset.hangmanTorso)
            }

            if stage > 2 {
                hangmanPart(Strings.Asset.hangmanLeftArm)
            }

            if stage > 3 {
                hangmanPart(Strings.Asset.hangmanRightArm)
            }

            if stage > 4 {
                hangmanPart(Strings.Asset.hangmanLeftLeg)
            }

            if stage > 5 {
                hangmanPart(Strings.Asset.hangmanRightLeg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(AppTheme.Motion.summaryReveal, value: stage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hangman stage \(stage)")
    }

    private func hangmanPart(_ assetName: String) -> some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .transition(.opacity.combined(with: .scale(scale: 0.94)))
    }
}

private struct WinCelebrationView: View {
    let isActive: Bool

    private let particles = Array(0..<18)
    private let colors: [Color] = [AppTheme.warning, AppTheme.primary, AppTheme.secondary, AppTheme.accent, AppTheme.success]

    var body: some View {
        ZStack {
            ForEach(particles, id: \.self) { index in
                let angle = (Double(index) / Double(particles.count)) * .pi * 2
                let radius = 56 + CGFloat(index % 4) * 16
                let xOffset = cos(angle) * radius
                let yOffset = sin(angle) * radius * 0.75
                let color = colors[index % colors.count]

                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(color)
                    .frame(width: index.isMultiple(of: 2) ? 10 : 6, height: 18)
                    .rotationEffect(.degrees(Double(index * 27)))
                    .offset(
                        x: isActive ? xOffset : 0,
                        y: isActive ? yOffset - 18 : 0
                    )
                    .opacity(isActive ? 0.95 : 0)
                    .scaleEffect(isActive ? 1 : 0.3)
                    .animation(
                        AppTheme.Motion.celebration.delay(Double(index) * 0.015),
                        value: isActive
                    )
            }
        }
        .frame(height: 130)
    }
}

#Preview {
    let viewModel = HangmanGameViewModel()
    viewModel.showCategorySelection(message: Strings.Message.start)
    viewModel.startRound(for: .animals, level: .medium)
    return GameScreenView(viewModel: viewModel, onGoToCategories: {}, onContinueAfterRound: {})
}
