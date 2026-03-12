//
//  MainView.swift
//  HangInThere
//
//  Created by Rafael Plinio on 12/03/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: AppViewModel

    init(
        wordRepository: any WordRepository = InMemoryWordRepository.default,
        progressRepository: any ProgressRepository = UserDefaultsProgressRepository()
    ) {
        _viewModel = StateObject(
            wrappedValue: AppViewModel(
                wordRepository: wordRepository,
                progressRepository: progressRepository
            )
        )
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            switch viewModel.phase {
            case .splash:
                SplashScreenView(onStart: viewModel.start)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            case .categorySelection:
                CategorySelectionView(viewModel: viewModel.gameViewModel, onChooseCategory: viewModel.chooseCategory)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            case .levelSelection:
                GameLevelSelectionView(
                    viewModel: viewModel.gameViewModel,
                    onChooseLevel: viewModel.chooseLevel,
                    onGoBack: viewModel.goToCategories
                )
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            case .game:
                GameScreenView(
                    viewModel: viewModel.gameViewModel,
                    onGoToCategories: viewModel.goToCategories,
                    onContinueAfterRound: viewModel.continueAfterRound
                )
                    .transition(.opacity)
            }
        }
        .animation(AppTheme.Motion.screenTransition, value: viewModel.phase)
    }
}

#Preview {
    MainView()
}
