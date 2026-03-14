//
//  MainView.swift
//  HangInThere
//
//  Created by Rafael Plinio on 12/03/26.
//

import SwiftUI

@MainActor
struct MainView: View {
    @StateObject private var viewModel: AppViewModel

    init(
        wordRepository: any WordRepository = InMemoryWordRepository.default,
        progressRepository: any ProgressRepository = UserDefaultsProgressRepository(),
        dailyQuestRepository: any DailyQuestRepository = UserDefaultsDailyQuestRepository(),
        soundPlayer: (any SoundPlaying)? = nil,
        hapticPlayer: (any HapticPlaying)? = nil
    ) {
        let resolvedSoundPlayer = soundPlayer ?? SoundEffectPlayer.shared
        let resolvedHapticPlayer = hapticPlayer ?? HapticFeedbackPlayer.shared
        _viewModel = StateObject(
            wrappedValue: AppViewModel(
                wordRepository: wordRepository,
                progressRepository: progressRepository,
                dailyQuestRepository: dailyQuestRepository,
                soundPlayer: resolvedSoundPlayer,
                hapticPlayer: resolvedHapticPlayer
            )
        )
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                AppTheme.background.ignoresSafeArea()

                phaseView

                if viewModel.phase != .splash {
                    topSafeAreaCover(height: proxy.safeAreaInsets.top)
                        .frame(height: proxy.safeAreaInsets.top)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .allowsHitTesting(false)
                }
            }
        }
        .animation(AppTheme.Motion.screenTransition, value: viewModel.phase)
        .preferredColorScheme(viewModel.phase == .splash ? .light : .dark)
        .sheet(isPresented: $viewModel.isShowingDailyQuests) {
            DailyQuestsView(viewModel: viewModel.gameViewModel, onClose: viewModel.closeDailyQuests)
        }
    }

    @ViewBuilder
    private func topSafeAreaCover(height: CGFloat) -> some View {
        AppTheme.topStatusBarFill
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var phaseView: some View {
        switch viewModel.phase {
        case .splash:
            SplashScreenView(onStart: viewModel.start)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.96)),
                    removal: .opacity
                ))
        case .categorySelection:
            CategorySelectionView(
                viewModel: viewModel.gameViewModel,
                onChooseCategory: viewModel.chooseCategory,
                onOpenDailyQuests: viewModel.openDailyQuests
            )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
        case .levelSelection:
            GameLevelSelectionView(
                viewModel: viewModel.gameViewModel,
                onChooseLevel: viewModel.chooseLevel,
                onGoBack: viewModel.goToCategories
            )
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
        case .game:
            GameScreenView(
                viewModel: viewModel.gameViewModel,
                onGoToCategories: viewModel.goToCategories,
                onContinueAfterRound: viewModel.continueAfterRound
            )
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

#Preview {
    MainView()
}
