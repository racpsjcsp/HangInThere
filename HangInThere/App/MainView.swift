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
        soundPlayer: (any SoundPlaying)? = nil
    ) {
        let resolvedSoundPlayer = soundPlayer ?? SoundEffectPlayer.shared
        _viewModel = StateObject(
            wrappedValue: AppViewModel(
                wordRepository: wordRepository,
                progressRepository: progressRepository,
                soundPlayer: resolvedSoundPlayer
            )
        )
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            phaseView
        }
        .animation(AppTheme.Motion.screenTransition, value: viewModel.phase)
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
            CategorySelectionView(viewModel: viewModel.gameViewModel, onChooseCategory: viewModel.chooseCategory)
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
