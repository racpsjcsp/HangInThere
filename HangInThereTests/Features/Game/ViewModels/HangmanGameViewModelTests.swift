//
//  HangmanGameViewModelTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

@MainActor
struct HangmanGameViewModelTests {
    @Test func usesInjectedWordRepository() async throws {
        let expectedWord = HangmanWord(answer: "Injected", hint: "From stub repository", difficulty: 2)
        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: expectedWord),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.startRound(for: .foods, level: .medium)
        }

        let word = await MainActor.run { viewModel.puzzle?.word }

        #expect(word == expectedWord)
    }

    @Test func loadsProgressFromRepository() async throws {
        var savedProgress = PlayerProgress()
        savedProgress.experience = 120
        savedProgress.level = 2
        savedProgress.revealLetterCharges = 5
        let repository = StubProgressRepository(storedProgress: savedProgress)

        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Saved", hint: "Stored", difficulty: 1)),
                progressRepository: repository
            )
        }

        let progress = await MainActor.run { viewModel.progress }

        #expect(progress == savedProgress)
    }

    @Test func persistsProgressAfterWinningRound() async throws {
        let repository = StubProgressRepository()
        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "A", hint: "Letter", difficulty: 1)),
                progressRepository: repository
            )
        }

        await MainActor.run {
            viewModel.startRound(for: .animals, level: .easy)
            viewModel.guess("A")
        }

        let progress = await MainActor.run { viewModel.progress }

        #expect(repository.storedProgress == progress)
        #expect(repository.storedProgress.experience > 0)
    }

    @Test func selectCategoryBuildsLevelSelectionState() async throws {
        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Level", hint: "Mode", difficulty: 2)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.selectCategory(.geography)
        }

        let state = await MainActor.run { viewModel.levelSelectionViewState }

        #expect(state?.categoryTitle == Strings.Category.geographyTitle)
        #expect(state?.levels.count == GameLevel.allCases.count)
        #expect(state?.levels.map(\.level) == GameLevel.allCases)
    }

    @Test func startRoundPublishesSelectedLevelInGameViewState() async throws {
        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Caracal", hint: "Wild cat", difficulty: 2)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.startRound(for: .animals, level: .hard)
        }

        let level = await MainActor.run { viewModel.currentLevel }
        let state = await MainActor.run { viewModel.gameViewState }

        #expect(level == .hard)
        #expect(state?.gameLevelTitle == Strings.Mode.hardTitle)
        #expect(state?.gameLevelSymbol == GameLevel.hard.symbol)
    }

    @Test func showCategorySelectionClearsSelectedDifficulty() async throws {
        let viewModel = await MainActor.run {
            HangmanGameViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Caracal", hint: "Wild cat", difficulty: 2)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.startRound(for: .animals, level: .medium)
            viewModel.showCategorySelection(message: Strings.Message.switchCategories)
        }

        let level = await MainActor.run { viewModel.currentLevel }
        let puzzle = await MainActor.run { viewModel.puzzle }

        #expect(level == nil)
        #expect(puzzle == nil)
    }
}
