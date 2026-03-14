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
    @State private var correctPulse = false
    @State private var wrongFlash = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var showWinCelebration = false

    var body: some View {
        if let state = viewModel.gameViewState {
            GeometryReader { proxy in
                let horizontalInset = horizontalPadding(for: proxy.size.width)
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.large) {
                        topBar(state: state)
                        puzzleCard(state: state)
                        if let summary = state.summary {
                            summaryCard(summary: summary)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .scale(scale: 0.96)).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            VStack(spacing: AppTheme.Spacing.large) {
                                powersCard(state: state)
                                keyboard(state: state)
                            }
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
                triggerCorrectFeedback()
            }
            .onChange(of: state.wrongValue) { oldValue, newValue in
                guard oldValue != newValue, state.isPlaying else { return }
                triggerWrongFeedback()
            }
            .onChange(of: state.summary?.title) { _, _ in
                triggerWinCelebrationIfNeeded(for: state.summary)
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
            Image(systemName: state.gameLevelSymbol)
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
            .font(AppTheme.Typography.caption())
            .foregroundStyle(Color.black.opacity(0.78))
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .padding(.horizontal, AppTheme.Spacing.xxxSmall)
            .padding(.vertical, 5)
            .background(color, in: Capsule())
            .fixedSize(horizontal: true, vertical: false)
    }

    private func puzzleCard(state: GameViewState) -> some View {
        AppCard {
            VStack(spacing: AppTheme.Spacing.medium) {
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(state.playerLevelText)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.textMuted)

                    HangmanDrawingView(stage: state.hangmanStage)
                        .frame(height: 126)
                        .padding(.horizontal, AppTheme.Spacing.medium)

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
        .overlay(alignment: .topTrailing) {
            soundToggleButton
                .padding(AppTheme.Spacing.small)
        }
        .scaleEffect(correctPulse ? 1.02 : 1)
        .modifier(ShakeEffect(animatableData: shakeTrigger))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous)
                .stroke(
                    wrongFlash
                    ? AppTheme.accent.opacity(0.8)
                    : AppTheme.success.opacity(correctPulse ? 0.75 : 0),
                    lineWidth: 2
                )
        }
        .shadow(
            color: wrongFlash
                ? AppTheme.accent.opacity(0.28)
                : AppTheme.success.opacity(correctPulse ? 0.25 : 0),
            radius: correctPulse || wrongFlash ? 18 : 0
        )
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
                        style: .powerReveal,
                        layout: .vertical,
                        size: .compact,
                        accessibilityIdentifier: AccessibilityID.Game.revealButton
                    ) {
                        viewModel.usePower(.revealLetter)
                    }

                    AppButton(
                        title: state.freeGuessButtonTitle,
                        systemImage: state.freeGuessButtonSymbol,
                        style: .powerFreeGuess,
                        layout: .vertical,
                        size: .compact,
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

private struct HangmanDrawingView: View {
    let stage: Int

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let lineWidth = max(3, min(size.width, size.height) * 0.028)
            let stroke = StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
            let frameColor = Color.white.opacity(0.82)
            let bodyColor = AppTheme.accent.opacity(0.96)

            ZStack {
                HangmanFrameShape()
                    .stroke(frameColor, style: stroke)

                if stage > 0 {
                    Circle()
                        .stroke(bodyColor, style: stroke)
                        .frame(width: size.width * 0.14, height: size.width * 0.14)
                        .position(x: size.width * 0.67, y: size.height * 0.24)
                        .transition(.scale.combined(with: .opacity))
                }

                if stage > 1 {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.67, y: size.height * 0.31))
                        path.addLine(to: CGPoint(x: size.width * 0.67, y: size.height * 0.58))
                    }
                    .stroke(bodyColor, style: stroke)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }

                if stage > 2 {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.67, y: size.height * 0.38))
                        path.addLine(to: CGPoint(x: size.width * 0.57, y: size.height * 0.48))
                    }
                    .stroke(bodyColor, style: stroke)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
                }

                if stage > 3 {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.67, y: size.height * 0.38))
                        path.addLine(to: CGPoint(x: size.width * 0.77, y: size.height * 0.48))
                    }
                    .stroke(bodyColor, style: stroke)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }

                if stage > 4 {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.67, y: size.height * 0.58))
                        path.addLine(to: CGPoint(x: size.width * 0.58, y: size.height * 0.74))
                    }
                    .stroke(bodyColor, style: stroke)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if stage > 5 {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.67, y: size.height * 0.58))
                        path.addLine(to: CGPoint(x: size.width * 0.76, y: size.height * 0.74))
                    }
                    .stroke(bodyColor, style: stroke)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .drawingGroup()
        .animation(AppTheme.Motion.summaryReveal, value: stage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hangman stage \(stage)")
    }
}

private struct HangmanFrameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.86))
        path.addLine(to: CGPoint(x: rect.width * 0.82, y: rect.height * 0.86))

        path.move(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.86))
        path.addLine(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.08))

        path.move(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.width * 0.67, y: rect.height * 0.08))

        path.move(to: CGPoint(x: rect.width * 0.67, y: rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.width * 0.67, y: rect.height * 0.13))

        path.move(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.width * 0.43, y: rect.height * 0.08))

        return path
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
