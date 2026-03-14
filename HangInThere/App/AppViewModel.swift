//
//  AppViewModel.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var phase: AppPhase = .splash
    @Published var isShowingDailyQuests = false
    let gameViewModel: HangmanGameViewModel
    private let startAppFlowUseCase = StartAppFlowUseCase()
    private let chooseCategoryFlowUseCase = ChooseCategoryFlowUseCase()
    private let chooseLevelFlowUseCase = ChooseLevelFlowUseCase()
    private let goToCategoriesFlowUseCase = GoToCategoriesFlowUseCase()
    private let continueAfterRoundFlowUseCase = ContinueAfterRoundFlowUseCase()

    init(
        wordRepository: any WordRepository,
        progressRepository: any ProgressRepository,
        dailyQuestRepository: any DailyQuestRepository = InMemoryDailyQuestRepository(),
        soundPlayer: (any SoundPlaying)? = nil,
        hapticPlayer: (any HapticPlaying)? = nil
    ) {
        let resolvedSoundPlayer = soundPlayer ?? SilentSoundPlayer.shared
        let resolvedHapticPlayer = hapticPlayer ?? SilentHapticPlayer.shared
        self.gameViewModel = HangmanGameViewModel(
            wordRepository: wordRepository,
            progressRepository: progressRepository,
            dailyQuestRepository: dailyQuestRepository,
            soundPlayer: resolvedSoundPlayer,
            hapticPlayer: resolvedHapticPlayer
        )
    }

    func openDailyQuests() {
        gameViewModel.refreshDailyQuests()
        isShowingDailyQuests = true
    }

    func closeDailyQuests() {
        isShowingDailyQuests = false
    }

    func start() {
        apply(startAppFlowUseCase.execute())
    }

    func chooseCategory(_ category: HangmanCategory) {
        apply(chooseCategoryFlowUseCase.execute(category: category))
    }

    func chooseLevel(_ level: GameLevel) {
        guard let category = gameViewModel.currentCategory else { return }
        apply(chooseLevelFlowUseCase.execute(category: category, level: level))
    }

    func goToCategories() {
        apply(goToCategoriesFlowUseCase.execute())
    }

    func continueAfterRound() {
        apply(continueAfterRoundFlowUseCase.execute(
            selectedCategory: gameViewModel.currentCategory,
            selectedLevel: gameViewModel.currentLevel
        ))
    }

    private func apply(_ transition: AppFlowTransition) {
        withAnimation(AppTheme.Motion.screenTransition) {
            if let message = transition.categorySelectionMessage {
                gameViewModel.showCategorySelection(message: message)
            }

            if transition.phase == .levelSelection, let category = transition.selectedCategory {
                gameViewModel.selectCategory(category)
            }

            if let category = transition.selectedCategory, let level = transition.selectedLevel {
                gameViewModel.startRound(for: category, level: level)
            }

            phase = transition.phase
        }
    }
}
