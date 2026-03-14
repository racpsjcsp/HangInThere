//
//  ViewStates.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct CategoryCardViewState: Identifiable {
    let category: HangmanCategory
    let title: String
    let description: String
    let symbol: String
    let tint: Color

    var id: HangmanCategory { category }
}

struct CategorySelectionViewState {
    let title: String
    let message: String
    let progressTitle: String
    let levelText: String
    let progressValue: Double
    let revealTitle: String
    let revealValue: String
    let freeGuessTitle: String
    let freeGuessValue: String
    let dailyQuestsTitle: String
    let dailyQuestsSummary: String
    let dailyQuestsButtonTitle: String
    let categories: [CategoryCardViewState]
}

struct LevelOptionViewState: Identifiable {
    let level: GameLevel
    let title: String
    let description: String
    let symbol: String
    let tint: Color

    var id: GameLevel { level }
}

struct GameLevelSelectionViewState {
    let title: String
    let subtitle: String
    let categoryTitle: String
    let categoryTint: Color
    let backButtonTitle: String
    let levels: [LevelOptionViewState]
}

struct SummaryViewState {
    let isWin: Bool
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
}

struct GameViewState {
    let categoryTitle: String
    let categoryTint: Color
    let gameLevelTitle: String
    let gameLevelSymbol: String
    let gameLevelTint: Color
    let categoriesButtonTitle: String
    let playerLevelText: String
    let hangmanStage: Int
    let maskedAnswer: String
    let hintTitle: String
    let hintText: String
    let livesTitle: String
    let livesValue: String
    let wrongTitle: String
    let wrongValue: String
    let showFreeGuessActive: Bool
    let freeGuessActiveText: String
    let message: String
    let revealButtonTitle: String
    let revealButtonSymbol: String
    let freeGuessButtonTitle: String
    let freeGuessButtonSymbol: String
    let keyboardRows: [[String]]
    let guessedLetters: Set<String>
    let isPlaying: Bool
    let summary: SummaryViewState?
}
