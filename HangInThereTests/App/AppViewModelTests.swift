//
//  AppViewModelTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

@MainActor
struct AppViewModelTests {
    @Test func startTransitionsToCategorySelection() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Start", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.start()
        }

        let phase = await MainActor.run { viewModel.phase }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let message = await MainActor.run { viewModel.gameViewModel.categorySelectionViewState.message }

        #expect(phase == .categorySelection)
        #expect(puzzle == nil)
        #expect(message == Strings.Message.start)
    }

    @Test func continueAfterRoundWithoutCategoryReturnsToSelection() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Return", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.continueAfterRound()
        }

        let phase = await MainActor.run { viewModel.phase }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let message = await MainActor.run { viewModel.gameViewModel.categorySelectionViewState.message }

        #expect(phase == .categorySelection)
        #expect(puzzle == nil)
        #expect(message == Strings.Message.switchCategories)
    }

    @Test func chooseCategoryTransitionsToLevelSelection() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Choose", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
        }

        let phase = await MainActor.run { viewModel.phase }
        let category = await MainActor.run { viewModel.gameViewModel.currentCategory }

        #expect(phase == .levelSelection)
        #expect(category == .animals)
    }

    @Test func chooseLevelTransitionsToGame() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Level", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
        }

        let phase = await MainActor.run { viewModel.phase }
        let level = await MainActor.run { viewModel.gameViewModel.currentLevel }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }

        #expect(phase == .game)
        #expect(level == .easy)
        #expect(puzzle?.category == .animals)
    }

    @Test func goToCategoriesFromLevelSelectionClearsSelectedCategoryAndLevel() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Back", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.hard)
            viewModel.goToCategories()
        }

        let phase = await MainActor.run { viewModel.phase }
        let category = await MainActor.run { viewModel.gameViewModel.currentCategory }
        let level = await MainActor.run { viewModel.gameViewModel.currentLevel }

        #expect(phase == .categorySelection)
        #expect(category == nil)
        #expect(level == nil)
    }

    @Test func continueAfterRoundKeepsSelectedDifficulty() async throws {
        let firstWord = HangmanWord(answer: "Caracal", hint: "First", difficulty: 2)
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: firstWord),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.medium)
            viewModel.continueAfterRound()
        }

        let phase = await MainActor.run { viewModel.phase }
        let level = await MainActor.run { viewModel.gameViewModel.currentLevel }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }

        #expect(phase == .game)
        #expect(level == .medium)
        #expect(puzzle?.category == .animals)
    }
}
