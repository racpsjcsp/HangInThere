//
//  HangmanGameViewModel.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HangmanGameViewModel: ObservableObject {
    @Published private(set) var progress = PlayerProgress()
    @Published private(set) var selectedCategory: HangmanCategory?
    @Published private(set) var selectedLevel: GameLevel?
    @Published private(set) var puzzle: HangmanPuzzle?
    @Published private(set) var message = Strings.Message.initial
    @Published private(set) var lastAwardedXP: Int = 0
    @Published private(set) var roundPhase: RoundPhase = .playing

    private let startRoundUseCase: StartRoundUseCase
    private let progressRepository: any ProgressRepository
    private let guessLetterUseCase = GuessLetterUseCase()
    private let usePowerUpUseCase = UsePowerUpUseCase()
    private let resolveRoundStateUseCase = ResolveRoundStateUseCase()

    convenience init() {
        self.init(
            wordRepository: InMemoryWordRepository.default,
            progressRepository: UserDefaultsProgressRepository()
        )
    }

    init(wordRepository: any WordRepository, progressRepository: any ProgressRepository) {
        self.startRoundUseCase = StartRoundUseCase(wordRepository: wordRepository)
        self.progressRepository = progressRepository
        self.progress = progressRepository.loadProgress()
    }

    var keyboardRows: [[String]] {
        [
            Array(Strings.Game.keyboardTopRow).map(String.init),
            Array(Strings.Game.keyboardMiddleRow).map(String.init),
            Array(Strings.Game.keyboardBottomRow).map(String.init)
        ]
    }

    var categorySelectionViewState: CategorySelectionViewState {
        CategorySelectionViewState(
            title: Strings.Selection.title,
            message: message,
            progressTitle: Strings.Selection.progressTitle,
            levelText: Strings.Selection.level(progress.level),
            progressValue: progress.progressToNextLevel,
            revealTitle: Strings.Selection.revealStat,
            revealValue: "\(progress.revealLetterCharges)",
            freeGuessTitle: Strings.Selection.freeGuessStat,
            freeGuessValue: "\(progress.freeGuessCharges)",
            categories: HangmanCategory.allCases.map { category in
                CategoryCardViewState(
                    category: category,
                    title: category.title,
                    description: description(for: category),
                    symbol: category.symbol,
                    tint: category.tint
                )
            }
        )
    }

    var gameViewState: GameViewState? {
        guard let puzzle, let selectedLevel else { return nil }

        let summary: SummaryViewState?
        if roundPhase == .summary {
            let isWin = puzzle.status == .won
            summary = SummaryViewState(
                isWin: isWin,
                title: isWin ? Strings.Game.wonTitle : Strings.Game.lostTitle,
                subtitle: isWin
                    ? Strings.Game.wonSubtitle(lastAwardedXP)
                    : Strings.Game.lostSubtitle(puzzle.answer),
                symbol: isWin ? Strings.Symbol.winSummary : Strings.Symbol.lossSummary,
                tint: isWin ? AppTheme.success : AppTheme.accent
            )
        } else {
            summary = nil
        }

        return GameViewState(
            categoryTitle: puzzle.category.title,
            categoryTint: puzzle.category.tint,
            gameLevelTitle: selectedLevel.title,
            gameLevelSymbol: selectedLevel.symbol,
            gameLevelTint: selectedLevel.tint,
            categoriesButtonTitle: Strings.Game.categories,
            playerLevelText: Strings.Selection.level(progress.level),
            face: face(for: puzzle.remainingLives),
            maskedAnswer: puzzle.maskedAnswer,
            hintTitle: Strings.Game.hint,
            hintText: puzzle.hint,
            livesTitle: Strings.Game.lives,
            livesValue: "\(puzzle.remainingLives)",
            wrongTitle: Strings.Game.wrong,
            wrongValue: puzzle.incorrectLetters.joined(separator: " ").ifEmpty(Strings.Game.none),
            showFreeGuessActive: puzzle.freeGuessShield,
            freeGuessActiveText: Strings.Game.freeGuessActive,
            message: message,
            revealButtonTitle: Strings.Game.revealButton(progress.revealLetterCharges),
            revealButtonSymbol: PowerUp.revealLetter.symbol,
            freeGuessButtonTitle: Strings.Game.freeGuessButton(progress.freeGuessCharges),
            freeGuessButtonSymbol: PowerUp.freeGuess.symbol,
            keyboardRows: keyboardRows,
            guessedLetters: Set(puzzle.guessedLetters.map { String($0) }),
            isPlaying: puzzle.status == .playing,
            summary: summary
        )
    }

    var levelSelectionViewState: GameLevelSelectionViewState? {
        guard let selectedCategory else { return nil }

        return GameLevelSelectionViewState(
            title: Strings.LevelSelection.title,
            subtitle: Strings.LevelSelection.subtitle(selectedCategory.title),
            categoryTitle: selectedCategory.title,
            categoryTint: selectedCategory.tint,
            backButtonTitle: Strings.LevelSelection.back,
            levels: GameLevel.allCases.map { level in
                LevelOptionViewState(
                    level: level,
                    title: level.title,
                    description: level.description,
                    symbol: level.symbol,
                    tint: level.tint
                )
            }
        )
    }

    var currentCategory: HangmanCategory? {
        selectedCategory
    }

    var currentLevel: GameLevel? {
        selectedLevel
    }

    func showCategorySelection(message: String) {
        withAnimation(AppTheme.Motion.screenTransition) {
            roundPhase = .playing
            selectedCategory = nil
            selectedLevel = nil
            puzzle = nil
            self.message = message
        }
    }

    func selectCategory(_ category: HangmanCategory) {
        withAnimation(AppTheme.Motion.screenTransition) {
            selectedCategory = category
            selectedLevel = nil
            puzzle = nil
            roundPhase = .playing
            message = Strings.LevelSelection.subtitle(category.title)
        }
    }

    func startRound(for category: HangmanCategory, level: GameLevel = .medium) {
        selectedCategory = category
        selectedLevel = level
        startRound(in: category, level: level)
    }

    func guess(_ letter: String) {
        guard let puzzle, let result = guessLetterUseCase.execute(puzzle: puzzle, letter: letter) else { return }
        withAnimation(AppTheme.Motion.cardBounce) {
            self.puzzle = result.puzzle
        }
        apply(resolveRoundStateUseCase.execute(
            puzzle: result.puzzle,
            progress: progress,
            previousWrongGuesses: result.previousWrongGuesses
        ))
    }

    func usePower(_ powerUp: PowerUp) {
        guard let puzzle else { return }

        switch usePowerUpUseCase.execute(puzzle: puzzle, progress: progress, powerUp: powerUp) {
        case .unavailable(let power):
            switch power {
            case .revealLetter:
                message = Strings.Message.noRevealCharges
            case .freeGuess:
                message = Strings.Message.noFreeGuessCharges
            }

        case .noEffect(let power):
            switch power {
            case .revealLetter:
                message = Strings.Message.nothingToReveal
            case .freeGuess:
                message = Strings.Message.freeGuessAlreadyActive
            }

        case .revealLetter(let puzzle, let progress, let revealed):
            self.puzzle = puzzle
            self.progress = progress
            persistProgress()
            message = Strings.Message.revealed(String(revealed))
            apply(resolveRoundStateUseCase.execute(
                puzzle: puzzle,
                progress: progress,
                previousWrongGuesses: puzzle.wrongGuesses
            ))

        case .freeGuessShield(let puzzle, let progress):
            self.puzzle = puzzle
            self.progress = progress
            persistProgress()
            message = Strings.Message.freeGuessActivated
        }
    }

    func isGuessed(_ letter: String) -> Bool {
        guard let character = letter.first, let puzzle else { return false }
        return puzzle.guessedLetters.contains(Character(String(character).uppercased()))
    }

    private func startRound(in category: HangmanCategory, level: GameLevel) {
        let nextPuzzle = startRoundUseCase.execute(category: category, level: level)
        withAnimation(AppTheme.Motion.screenTransition) {
            puzzle = nextPuzzle
            roundPhase = .playing
            lastAwardedXP = 0
            message = Strings.Message.makeFirstGuess
        }
    }

    private func apply(_ resolution: RoundResolution) {
        switch resolution {
        case .playing(let wrongGuessesChanged, let freeGuessShield, let remainingLives):
            if !wrongGuessesChanged {
                message = freeGuessShield
                    ? Strings.Message.freeGuessReady
                    : Strings.Message.goodGuess
            } else {
                message = Strings.Message.missed(remainingLives)
            }

        case .won(let puzzle, let progress, let reward, let levelsGained):
            withAnimation(AppTheme.Motion.summaryReveal) {
                self.puzzle = puzzle
                self.progress = progress
                lastAwardedXP = reward
                roundPhase = .summary
            }
            persistProgress()
            message = levelsGained > 0
                ? Strings.Message.levelUp(progress.level)
                : Strings.Message.roundWon(reward)

        case .lost(let puzzle):
            withAnimation(AppTheme.Motion.summaryReveal) {
                self.puzzle = puzzle
                roundPhase = .summary
            }
            lastAwardedXP = 0
            message = Strings.Message.roundLost(puzzle.answer)
        }
    }

    private func description(for category: HangmanCategory) -> String {
        switch category {
        case .animals:
            Strings.Category.animalsDescription
        case .geography:
            Strings.Category.geographyDescription
        case .foods:
            Strings.Category.foodsDescription
        case .objects:
            Strings.Category.objectsDescription
        }
    }

    private func face(for remainingLives: Int) -> String {
        switch remainingLives {
        case 6: Strings.Face.fullLives
        case 5: Strings.Face.fiveLives
        case 4: Strings.Face.fourLives
        case 3: Strings.Face.threeLives
        case 2: Strings.Face.twoLives
        case 1: Strings.Face.oneLife
        default: Strings.Face.noLives
        }
    }

    private func persistProgress() {
        progressRepository.saveProgress(progress)
    }
}

private extension String {
    func ifEmpty(_ fallback: String) -> String {
        isEmpty ? fallback : self
    }
}
