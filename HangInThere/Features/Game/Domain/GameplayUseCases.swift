//
//  GameplayUseCases.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

struct StartRoundUseCase {
    let wordRepository: any WordRepository

    func execute(category: HangmanCategory, level: GameLevel) -> HangmanPuzzle {
        let word = wordRepository.randomWord(for: category, level: level)
        return HangmanPuzzle(category: category, word: word)
    }
}

struct GuessLetterUseCase {
    func execute(puzzle: HangmanPuzzle, letter: String) -> GuessLetterResult? {
        guard let character = letter.first else { return nil }

        var updatedPuzzle = puzzle
        let previousWrongGuesses = updatedPuzzle.wrongGuesses
        updatedPuzzle.guess(character)

        return GuessLetterResult(
            puzzle: updatedPuzzle,
            previousWrongGuesses: previousWrongGuesses
        )
    }
}

struct UsePowerUpUseCase {
    private let spendPowerChargeUseCase: SpendPowerChargeUseCase

    init(spendPowerChargeUseCase: SpendPowerChargeUseCase = SpendPowerChargeUseCase()) {
        self.spendPowerChargeUseCase = spendPowerChargeUseCase
    }

    func execute(puzzle: HangmanPuzzle, progress: PlayerProgress, powerUp: PowerUp) -> PowerUpUseResult {
        var updatedPuzzle = puzzle

        switch powerUp {
        case .revealLetter:
            guard progress.revealLetterCharges > 0 else {
                return .unavailable(.revealLetter)
            }

            guard let revealed = updatedPuzzle.useRevealPower() else {
                return .noEffect(.revealLetter)
            }

            guard let updatedProgress = spendPowerChargeUseCase.execute(
                progress: progress,
                powerUp: .revealLetter
            ) else {
                return .unavailable(.revealLetter)
            }

            return .revealLetter(
                puzzle: updatedPuzzle,
                progress: updatedProgress,
                revealed: revealed
            )

        case .freeGuess:
            guard progress.freeGuessCharges > 0 else {
                return .unavailable(.freeGuess)
            }

            guard updatedPuzzle.useFreeGuessShield() else {
                return .noEffect(.freeGuess)
            }

            guard let updatedProgress = spendPowerChargeUseCase.execute(
                progress: progress,
                powerUp: .freeGuess
            ) else {
                return .unavailable(.freeGuess)
            }

            return .freeGuessShield(
                puzzle: updatedPuzzle,
                progress: updatedProgress
            )
        }
    }
}

struct ResolveRoundStateUseCase {
    private let awardProgressUseCase: AwardProgressUseCase

    init(awardProgressUseCase: AwardProgressUseCase = AwardProgressUseCase()) {
        self.awardProgressUseCase = awardProgressUseCase
    }

    func execute(puzzle: HangmanPuzzle, progress: PlayerProgress, previousWrongGuesses: Int) -> RoundResolution {
        switch puzzle.status {
        case .playing:
            return .playing(
                wrongGuessesChanged: puzzle.wrongGuesses != previousWrongGuesses,
                freeGuessShield: puzzle.freeGuessShield,
                remainingLives: puzzle.remainingLives
            )

        case .won:
            let reward = 35 + (puzzle.remainingLives * 8) + (puzzle.word.difficulty * 10)
            let award = awardProgressUseCase.execute(progress: progress, reward: reward)
            return .won(
                puzzle: puzzle,
                progress: award.progress,
                reward: reward,
                levelsGained: award.levelsGained
            )

        case .lost:
            return .lost(puzzle: puzzle)
        }
    }
}

struct GuessLetterResult {
    let puzzle: HangmanPuzzle
    let previousWrongGuesses: Int
}

enum PowerUpUseResult {
    case unavailable(PowerUp)
    case noEffect(PowerUp)
    case revealLetter(puzzle: HangmanPuzzle, progress: PlayerProgress, revealed: Character)
    case freeGuessShield(puzzle: HangmanPuzzle, progress: PlayerProgress)
}

enum RoundResolution {
    case playing(wrongGuessesChanged: Bool, freeGuessShield: Bool, remainingLives: Int)
    case won(puzzle: HangmanPuzzle, progress: PlayerProgress, reward: Int, levelsGained: Int)
    case lost(puzzle: HangmanPuzzle)
}
