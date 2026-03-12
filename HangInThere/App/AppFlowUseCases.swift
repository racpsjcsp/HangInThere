//
//  AppFlowUseCases.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

struct StartAppFlowUseCase {
    func execute() -> AppFlowTransition {
        AppFlowTransition(
            phase: .categorySelection,
            categorySelectionMessage: Strings.Message.start
        )
    }
}

struct ChooseCategoryFlowUseCase {
    func execute(category: HangmanCategory) -> AppFlowTransition {
        AppFlowTransition(
            phase: .levelSelection,
            selectedCategory: category
        )
    }
}

struct ChooseLevelFlowUseCase {
    func execute(category: HangmanCategory, level: GameLevel) -> AppFlowTransition {
        AppFlowTransition(
            phase: .game,
            selectedCategory: category,
            selectedLevel: level
        )
    }
}

struct GoToCategoriesFlowUseCase {
    func execute() -> AppFlowTransition {
        AppFlowTransition(
            phase: .categorySelection,
            categorySelectionMessage: Strings.Message.switchCategories
        )
    }
}

struct ContinueAfterRoundFlowUseCase {
    func execute(selectedCategory: HangmanCategory?, selectedLevel: GameLevel?) -> AppFlowTransition {
        if let selectedCategory, let selectedLevel {
            return AppFlowTransition(
                phase: .game,
                selectedCategory: selectedCategory,
                selectedLevel: selectedLevel
            )
        }

        return AppFlowTransition(
            phase: .categorySelection,
            categorySelectionMessage: Strings.Message.switchCategories
        )
    }
}

struct AppFlowTransition {
    let phase: AppPhase
    var selectedCategory: HangmanCategory? = nil
    var selectedLevel: GameLevel? = nil
    var categorySelectionMessage: String? = nil
}
