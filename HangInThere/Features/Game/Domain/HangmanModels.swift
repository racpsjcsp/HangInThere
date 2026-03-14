//
//  HangmanModels.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation
import SwiftUI

struct HangmanWord: Equatable {
    let answer: String
    let hint: String
    let difficulty: Int
}

protocol WordRepository {
    func randomWord(for category: HangmanCategory, level: GameLevel) -> HangmanWord
}

enum HangmanCategory: String, CaseIterable, Identifiable, Codable {
    case animals
    case geography
    case foods
    case objects

    var id: String { rawValue }

    var title: String {
        switch self {
        case .animals: Strings.Category.animalsTitle
        case .geography: Strings.Category.geographyTitle
        case .foods: Strings.Category.foodsTitle
        case .objects: Strings.Category.objectsTitle
        }
    }

    var symbol: String {
        switch self {
        case .animals: Strings.Symbol.animals
        case .geography: Strings.Symbol.geography
        case .foods: Strings.Symbol.foods
        case .objects: Strings.Symbol.objects
        }
    }

    var tint: Color {
        switch self {
        case .animals: AppTheme.secondary
        case .geography: AppTheme.primary
        case .foods: AppTheme.warning
        case .objects: AppTheme.accent
        }
    }
}

enum AppPhase {
    case splash
    case categorySelection
    case levelSelection
    case game
}

enum RoundPhase {
    case playing
    case summary
}

enum RoundStatus {
    case playing
    case won
    case lost
}

enum PowerUp: String, CaseIterable, Identifiable {
    case revealLetter
    case freeGuess

    var id: String { rawValue }

    var title: String {
        switch self {
        case .revealLetter: Strings.Power.revealTitle
        case .freeGuess: Strings.Power.freeGuessTitle
        }
    }

    var symbol: String {
        switch self {
        case .revealLetter: Strings.Symbol.revealPower
        case .freeGuess: Strings.Symbol.freeGuessPower
        }
    }
}

enum GameLevel: String, CaseIterable, Identifiable, Codable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: Strings.Mode.easyTitle
        case .medium: Strings.Mode.mediumTitle
        case .hard: Strings.Mode.hardTitle
        }
    }

    var description: String {
        switch self {
        case .easy: Strings.Mode.easyDescription
        case .medium: Strings.Mode.mediumDescription
        case .hard: Strings.Mode.hardDescription
        }
    }

    var symbol: String {
        switch self {
        case .easy: "leaf.fill"
        case .medium: "flame.fill"
        case .hard: "bolt.fill"
        }
    }

    var tint: Color {
        switch self {
        case .easy: AppTheme.secondary
        case .medium: AppTheme.warning
        case .hard: AppTheme.accent
        }
    }
}

struct PlayerProgress: Equatable, Codable {
    static let powerUnlockLevel = 3
    static let maxPowerCharges = 2

    var level: Int = 1
    var experience: Int = 0
    var revealLetterCharges: Int = 0
    var freeGuessCharges: Int = 0

    var progressToNextLevel: Double {
        Double(experienceWithinCurrentLevel) / Double(experienceRequiredForCurrentLevel)
    }

    var experienceWithinCurrentLevel: Int {
        experience - Self.experienceRequired(before: level)
    }

    var experienceRequiredForCurrentLevel: Int {
        Self.experienceRequired(for: level)
    }

    mutating func awardExperience(_ amount: Int) -> Int {
        experience += amount
        let previousLevel = level

        while experience >= Self.experienceRequired(before: level + 1) {
            level += 1
        }

        if level > previousLevel {
            applyPowerRewards(from: previousLevel + 1, through: level)
        }

        return level - previousLevel
    }

    private mutating func applyPowerRewards(from startLevel: Int, through endLevel: Int) {
        guard startLevel <= endLevel else { return }

        for reachedLevel in startLevel...endLevel {
            if reachedLevel == Self.powerUnlockLevel {
                revealLetterCharges = min(revealLetterCharges + 1, Self.maxPowerCharges)
                freeGuessCharges = min(freeGuessCharges + 1, Self.maxPowerCharges)
                continue
            }

            if reachedLevel > Self.powerUnlockLevel, (reachedLevel - Self.powerUnlockLevel) % 3 == 0 {
                freeGuessCharges = min(freeGuessCharges + 1, Self.maxPowerCharges)
            }

            if reachedLevel > Self.powerUnlockLevel, (reachedLevel - Self.powerUnlockLevel) % 6 == 0 {
                revealLetterCharges = min(revealLetterCharges + 1, Self.maxPowerCharges)
            }
        }
    }

    static func experienceRequired(for level: Int) -> Int {
        80 + max(level - 1, 0) * 40
    }

    static func experienceRequired(before level: Int) -> Int {
        guard level > 1 else { return 0 }
        return (1..<level).reduce(0) { partial, current in
            partial + experienceRequired(for: current)
        }
    }
}

struct HangmanPuzzle: Equatable {
    let category: HangmanCategory
    let word: HangmanWord
    var guessedLetters: Set<Character> = []
    var wrongGuesses: Int = 0
    var freeGuessShield = false
    let maxMistakes: Int = 6

    var answer: String { word.answer.uppercased() }
    var hint: String { word.hint }
    var maskedAnswer: String {
        answer.map { character in
            if character == Character(Strings.Game.blankCharacter) || guessedLetters.contains(character) {
                return String(character)
            }
            return Strings.Game.maskedLetter
        }
        .joined(separator: Strings.Game.maskedSeparator)
    }

    var incorrectLetters: [String] {
        guessedLetters
            .filter { !answer.contains($0) }
            .sorted()
            .map(String.init)
    }

    var remainingLives: Int { maxMistakes - wrongGuesses }

    var status: RoundStatus {
        if isSolved { return .won }
        if wrongGuesses >= maxMistakes { return .lost }
        return .playing
    }

    var isSolved: Bool {
        answer
            .filter { $0 != Character(Strings.Game.blankCharacter) }
            .allSatisfy { guessedLetters.contains($0) }
    }

    mutating func guess(_ letter: Character) {
        let normalized = Character(String(letter).uppercased())
        guard normalized.isLetter, !guessedLetters.contains(normalized), status == .playing else { return }

        guessedLetters.insert(normalized)

        guard !answer.contains(normalized) else { return }

        if freeGuessShield {
            freeGuessShield = false
        } else {
            wrongGuesses += 1
        }
    }

    mutating func useRevealPower() -> Character? {
        guard status == .playing else { return nil }

        let hiddenLetters = Array(Set(answer.filter { $0 != Character(Strings.Game.blankCharacter) && !guessedLetters.contains($0) }))
        guard let letter = hiddenLetters.sorted().first else { return nil }
        guessedLetters.insert(letter)
        return letter
    }

    mutating func useFreeGuessShield() -> Bool {
        guard status == .playing, !freeGuessShield else { return false }
        freeGuessShield = true
        return true
    }
}

final class InMemoryWordRepository: WordRepository {
    let wordsByCategoryAndLevel: [HangmanCategory: [GameLevel: [HangmanWord]]]
    private var remainingWordsByCategoryAndLevel: [HangmanCategory: [GameLevel: [HangmanWord]]]

    init(wordsByCategoryAndLevel: [HangmanCategory: [GameLevel: [HangmanWord]]]) {
        self.wordsByCategoryAndLevel = wordsByCategoryAndLevel
        self.remainingWordsByCategoryAndLevel = wordsByCategoryAndLevel.mapValues { levels in
            levels.mapValues { $0.shuffled() }
        }
    }

    init(wordsByCategory: [HangmanCategory: [HangmanWord]]) {
        let leveledWords = Dictionary(
            uniqueKeysWithValues: wordsByCategory.map { category, words in
                (
                    category,
                    Dictionary(
                        uniqueKeysWithValues: GameLevel.allCases.map { level in
                            (level, words)
                        }
                    )
                )
            }
        )
        self.wordsByCategoryAndLevel = leveledWords
        self.remainingWordsByCategoryAndLevel = leveledWords.mapValues { levels in
            levels.mapValues { $0.shuffled() }
        }
    }

    func randomWord(for category: HangmanCategory, level: GameLevel) -> HangmanWord {
        if let nextWord = dequeueWord(for: category, level: level) {
            return nextWord
        }

        if let fallbackLevel = GameLevel.allCases.first(where: { !(wordsByCategoryAndLevel[category]?[$0]?.isEmpty ?? true) }),
           let fallbackWord = dequeueWord(for: category, level: fallbackLevel) {
            return fallbackWord
        }

        return HangmanWord(
            answer: Strings.Fallback.answer,
            hint: Strings.Fallback.hint,
            difficulty: 1
        )
    }

    private func dequeueWord(for category: HangmanCategory, level: GameLevel) -> HangmanWord? {
        if remainingWordsByCategoryAndLevel[category]?[level]?.isEmpty == true {
            remainingWordsByCategoryAndLevel[category]?[level] = wordsByCategoryAndLevel[category]?[level]?.shuffled() ?? []
        }

        return remainingWordsByCategoryAndLevel[category]?[level]?.popLast()
    }

    static let `default` = InMemoryWordRepository(wordsByCategoryAndLevel: GameWordBank.wordsByCategoryAndLevel)
}
