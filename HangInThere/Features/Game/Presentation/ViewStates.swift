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
    let imageName: String

    var id: HangmanCategory { category }
}

struct CategorySelectionViewState {
    let title: String
    let message: String
    let progressTitle: String
    let levelText: String
    let progressValue: Double
    let nextRewardText: String
    let revealTitle: String
    let revealValue: String
    let freeGuessTitle: String
    let freeGuessValue: String
    let dailyQuestsTitle: String
    let dailyQuestsSummary: String
    let dailyQuestsButtonTitle: String
    let settingsButtonTitle: String
    let categories: [CategoryCardViewState]
}

struct LevelOptionViewState: Identifiable {
    let level: GameLevel
    let title: String
    let description: String
    let imageName: String
    let imageScale: CGFloat
    let resumeText: String?

    var id: GameLevel { level }
}

struct GameLevelSelectionViewState {
    let title: String
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
    let levelUpTitle: String?
    let levelUpSubtitle: String?
    let powerRewardTitle: String?
    let powerRewardSubtitle: String?
}

struct GameViewState {
    let categoryTitle: String
    let categoryTint: Color
    let gameLevelTitle: String
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
    let revealButtonImageName: String
    let freeGuessButtonTitle: String
    let freeGuessButtonImageName: String
    let keyboardRows: [[String]]
    let guessedLetters: Set<String>
    let isPlaying: Bool
    let summary: SummaryViewState?
}

struct SettingsMenuViewState {
    let title: String
    let subtitle: String
    let soundEnabled: Bool
    let hapticsEnabled: Bool
    let playerLevelText: String
    let progressText: String
    let nextRewardText: String
    let storageNote: String
}
