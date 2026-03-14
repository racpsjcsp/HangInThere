//
//  DailyQuestModels.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import Foundation

enum DailyQuestDifficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case challenge

    var baseRewardXP: Int {
        switch self {
        case .easy:
            50
        case .medium:
            100
        case .challenge:
            150
        }
    }
}

enum DailyQuestKind: String, Codable, CaseIterable, Identifiable {
    case playThreeRounds
    case winOneRound
    case earnHundredXP
    case useOnePowerUp
    case guessTenCorrectLetters

    case winThreeRounds
    case earnTwoHundredXP
    case winOneMediumRound
    case playTwoCategories
    case finishRoundWithThreeLives

    case winOneHardRound
    case solveRoundWithoutPowers
    case playThreeCategories
    case winTwoRoundsInARow

    var id: String { rawValue }

    var difficulty: DailyQuestDifficulty {
        switch self {
        case .playThreeRounds, .winOneRound, .earnHundredXP, .useOnePowerUp, .guessTenCorrectLetters:
            .easy
        case .winThreeRounds, .earnTwoHundredXP, .winOneMediumRound, .playTwoCategories, .finishRoundWithThreeLives:
            .medium
        case .winOneHardRound, .solveRoundWithoutPowers, .playThreeCategories, .winTwoRoundsInARow:
            .challenge
        }
    }

    var goal: Int {
        switch self {
        case .playThreeRounds:
            3
        case .winOneRound, .useOnePowerUp, .winOneMediumRound, .finishRoundWithThreeLives, .winOneHardRound, .solveRoundWithoutPowers:
            1
        case .earnHundredXP:
            100
        case .guessTenCorrectLetters:
            10
        case .winThreeRounds, .playThreeCategories:
            3
        case .earnTwoHundredXP:
            200
        case .playTwoCategories, .winTwoRoundsInARow:
            2
        }
    }

    func progressValue(from stats: DailyQuestStats) -> Int {
        switch self {
        case .playThreeRounds:
            stats.roundsPlayed
        case .winOneRound, .winThreeRounds:
            stats.roundsWon
        case .earnHundredXP, .earnTwoHundredXP:
            stats.roundExperienceEarned
        case .useOnePowerUp:
            stats.powerUpsUsed
        case .guessTenCorrectLetters:
            stats.correctLettersGuessed
        case .winOneMediumRound:
            stats.mediumWins
        case .playTwoCategories, .playThreeCategories:
            stats.categoriesPlayed.count
        case .finishRoundWithThreeLives:
            stats.roundsWonWithThreeOrMoreLives
        case .winOneHardRound:
            stats.hardWins
        case .solveRoundWithoutPowers:
            stats.roundsWonWithoutPowers
        case .winTwoRoundsInARow:
            stats.highestWinStreak
        }
    }
}

struct DailyQuest: Codable, Equatable, Identifiable {
    let kind: DailyQuestKind
    var progress: Int = 0
    var isClaimed = false
    let rewardXP: Int

    var id: DailyQuestKind { kind }
    var isCompleted: Bool { progress >= kind.goal }
}

struct DailyQuestStats: Codable, Equatable {
    var roundsPlayed = 0
    var roundsWon = 0
    var mediumWins = 0
    var hardWins = 0
    var categoriesPlayed: Set<HangmanCategory> = []
    var roundExperienceEarned = 0
    var powerUpsUsed = 0
    var correctLettersGuessed = 0
    var currentWinStreak = 0
    var highestWinStreak = 0
    var roundsWonWithoutPowers = 0
    var roundsWonWithThreeOrMoreLives = 0
}

struct DailyQuestState: Codable, Equatable {
    static let completionBonusBaseXP = 200

    var generatedOn: Date
    var quests: [DailyQuest]
    var stats = DailyQuestStats()
    var completionBonusXP: Int
    var isCompletionBonusClaimed = false

    var isSundayBonus: Bool {
        completionBonusXP > Self.completionBonusBaseXP
    }

    var allQuestsCompleted: Bool {
        quests.allSatisfy(\.isCompleted)
    }

    var completedQuestCount: Int {
        quests.filter(\.isCompleted).count
    }
}

enum DailyQuestEvent {
    case roundStarted(category: HangmanCategory)
    case correctGuess
    case powerUpUsed
    case roundWon(level: GameLevel, reward: Int, remainingLives: Int, usedPowerUp: Bool)
    case roundLost
}

