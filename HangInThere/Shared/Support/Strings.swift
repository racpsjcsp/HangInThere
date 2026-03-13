//
//  Strings.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

enum Strings {
    enum Symbol {
        static let animals = "pawprint.fill"
        static let geography = "globe.americas.fill"
        static let foods = "fork.knife"
        static let objects = "shippingbox.fill"

        static let revealPower = "sparkles"
        static let freeGuessPower = "shield.lefthalf.filled"

        static let splashCategoriesFeature = "square.stack.3d.up.fill"
        static let splashProgressionFeature = "chart.line.uptrend.xyaxis"
        static let splashPowersFeature = "wand.and.stars"

        static let categoriesButton = "square.grid.2x2"
        static let nextRoundButton = "arrow.right.circle.fill"
        static let changeCategoryButton = "arrow.uturn.backward.circle"
        static let startButton = "play.fill"
        static let winSummary = "party.popper.fill"
        static let lossSummary = "arrow.counterclockwise.circle.fill"
        static let soundOn = "speaker.wave.2.fill"
        static let soundOff = "speaker.slash.fill"
    }

    enum Category {
        static let animalsTitle = "Animals"
        static let geographyTitle = "Geography"
        static let foodsTitle = "Foods"
        static let objectsTitle = "Objects"

        static let animalsDescription = "From playful mammals to tricky reptiles."
        static let geographyDescription = "Cities, deserts, islands, and giant landmarks."
        static let foodsDescription = "Comfort dishes and classics from around the world."
        static let objectsDescription = "Everyday tools and vintage finds."
    }

    enum Power {
        static let revealTitle = "Reveal Letter"
        static let freeGuessTitle = "Free Guess"
    }

    enum Splash {
        static let badge = "Word Adventure"
        static let title = "Hang In There"
        static let subtitle = "A pick-up-and-play word game with clear hints, smart difficulty levels, and satisfying progression."
        static let featuresTitle = "Game Features"
        static let categoriesFeature = "Play across Animals, Geography, Foods, and Objects"
        static let progressionFeature = "Level up, unlock powers at level 3, and earn limited refills over time"
        static let powersFeature = "Use Reveal Letter and Free Guess when a round gets tense"
        static let start = "Start Playing"
    }

    enum Selection {
        static let title = "Choose your category"
        static let progressTitle = "Player Progress"
        static let revealStat = "Reveal"
        static let freeGuessStat = "Free Guess"

        static func level(_ value: Int) -> String {
            "Level \(value)"
        }
    }

    enum LevelSelection {
        static let title = "Choose the challenge"
        static let back = "Back to Categories"

        static func subtitle(_ category: String) -> String {
            "Category selected: \(category). Pick your difficulty."
        }
    }

    enum Mode {
        static let easyTitle = "Easy"
        static let mediumTitle = "Medium"
        static let hardTitle = "Hard"

        static let easyDescription = "Shorter, more familiar answers."
        static let mediumDescription = "Balanced challenge with trickier guesses."
        static let hardDescription = "Long, obscure, and punishing words."
    }

    enum Game {
        static let categories = "Categories"
        static let level = "Mode"
        static let hint = "Hint"
        static let lives = "Lives"
        static let wrong = "Wrong"
        static let none = "None"
        static let freeGuessActive = "Free Guess Active"
        static let powersTitle = "Power Items"
        static let wonTitle = "Round Cleared"
        static let lostTitle = "Try Again"
        static let nextRound = "Next Round"
        static let changeCategory = "Change Category"
        static let soundOn = "Sound On"
        static let soundOff = "Sound Off"
        static let keyboardTopRow = "QWERTYUIOP"
        static let keyboardMiddleRow = "ASDFGHJKL"
        static let keyboardBottomRow = "ZXCVBNM"
        static let maskedLetter = "_"
        static let maskedSeparator = " "
        static let blankCharacter = " "

        static func revealButton(_ charges: Int) -> String {
            "Reveal (\(charges))"
        }

        static func freeGuessButton(_ charges: Int) -> String {
            "Free Guess (\(charges))"
        }

        static func wonSubtitle(_ xp: Int) -> String {
            "+\(xp) XP earned"
        }

        static func lostSubtitle(_ answer: String) -> String {
            "The answer was \(answer)"
        }
    }

    enum Message {
        static let initial = "Guess smart. Save your powers for the hard words."
        static let start = "Pick a category and start climbing levels."
        static let noRevealCharges = "No Reveal Letter charges left."
        static let nothingToReveal = "Everything useful is already visible."
        static let noFreeGuessCharges = "No Free Guess charges left."
        static let freeGuessAlreadyActive = "Free Guess is already active."
        static let freeGuessActivated = "Shield up. Your next mistake won't cost a life."
        static let switchCategories = "Switch categories any time."
        static let makeFirstGuess = "Make your first guess."
        static let freeGuessReady = "Nice. The Free Guess shield is still ready."
        static let goodGuess = "Solid guess. Keep the streak going."

        static func revealed(_ letter: String) -> String {
            "Revealed \(letter)."
        }

        static func missed(_ lives: Int) -> String {
            "Missed. \(lives) lives left."
        }

        static func levelUp(_ level: Int) -> String {
            "You won and leveled up to \(level)."
        }

        static func roundWon(_ reward: Int) -> String {
            "You solved it. +\(reward) XP."
        }

        static func roundLost(_ answer: String) -> String {
            "Round over. The word was \(answer)."
        }
    }

    enum Fallback {
        static let answer = "SWIFT"
        static let hint = "Apple development language"
    }

    enum Face {
        static let fullLives = "😎"
        static let fiveLives = "🙂"
        static let fourLives = "😐"
        static let threeLives = "😬"
        static let twoLives = "😵"
        static let oneLife = "🥴"
        static let noLives = "💀"
    }

}
