//
//  AccessibilityIdentifiers.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

enum AccessibilityID {
    enum Splash {
        static let title = "splash.title"
        static let startButton = "splash.startButton"
    }

    enum CategorySelection {
        static let title = "categorySelection.title"

        static func categoryButton(_ category: HangmanCategory) -> String {
            "categorySelection.category.\(category.rawValue)"
        }
    }

    enum LevelSelection {
        static let title = "levelSelection.title"
        static let backButton = "levelSelection.backButton"

        static func levelButton(_ level: GameLevel) -> String {
            "levelSelection.level.\(level.rawValue)"
        }
    }

    enum Game {
        static let categoryTitle = "game.categoryTitle"
        static let modeBadge = "game.modeBadge"
        static let categoriesButton = "game.categoriesButton"
        static let soundToggleButton = "game.soundToggleButton"
        static let maskedAnswer = "game.maskedAnswer"
        static let hintText = "game.hintText"
        static let revealButton = "game.revealButton"
        static let freeGuessButton = "game.freeGuessButton"
        static let summaryTitle = "game.summaryTitle"
        static let nextRoundButton = "game.nextRoundButton"
        static let changeCategoryButton = "game.changeCategoryButton"

        static func keyboardButton(_ letter: String) -> String {
            "game.keyboard.\(letter)"
        }
    }
}
