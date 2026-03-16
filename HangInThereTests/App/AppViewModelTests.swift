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

    @Test func openingAndClosingSettingsUpdatesSheetState() async throws {
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: HangmanWord(answer: "Flow", hint: "Settings", difficulty: 1)),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.openSettings()
        }

        #expect(await MainActor.run { viewModel.isShowingSettings } == true)

        await MainActor.run {
            viewModel.closeSettings()
        }

        #expect(await MainActor.run { viewModel.isShowingSettings } == false)
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

    @Test func returningToSameCategoryAndLevelResumesInProgressRound() async throws {
        let word = HangmanWord(answer: "AB", hint: "Letters", difficulty: 1)
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: word),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
            viewModel.gameViewModel.guess("A")
            viewModel.goToCategories()
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
        }

        let phase = await MainActor.run { viewModel.phase }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let maskedAnswer = await MainActor.run { viewModel.gameViewModel.gameViewState?.maskedAnswer }

        #expect(phase == .game)
        #expect(puzzle?.guessedLetters == ["A"])
        #expect(maskedAnswer == "A _")
    }

    @Test func eachDifficultyResumesItsOwnInProgressRound() async throws {
        let word = HangmanWord(answer: "AB", hint: "Letters", difficulty: 1)
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: word),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
            viewModel.gameViewModel.guess("A")
            viewModel.goToCategories()
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.medium)
            viewModel.gameViewModel.guess("B")
            viewModel.goToCategories()
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
        }

        let phase = await MainActor.run { viewModel.phase }
        let puzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let maskedAnswer = await MainActor.run { viewModel.gameViewModel.gameViewState?.maskedAnswer }

        #expect(phase == .game)
        #expect(puzzle?.guessedLetters == ["A"])
        #expect(maskedAnswer == "A _")

        await MainActor.run {
            viewModel.goToCategories()
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.medium)
        }

        let mediumPuzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let mediumMaskedAnswer = await MainActor.run { viewModel.gameViewModel.gameViewState?.maskedAnswer }

        #expect(mediumPuzzle?.guessedLetters == ["B"])
        #expect(mediumMaskedAnswer == "_ B")
    }

    @Test func eachCategoryAndDifficultyPairKeepsItsOwnSuspendedRound() async throws {
        let word = HangmanWord(answer: "AB", hint: "Letters", difficulty: 1)
        let viewModel = await MainActor.run {
            AppViewModel(
                wordRepository: StubWordRepository(word: word),
                progressRepository: StubProgressRepository()
            )
        }

        await MainActor.run {
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
            viewModel.gameViewModel.guess("A")
            viewModel.goToCategories()
            viewModel.chooseCategory(.foods)
            viewModel.chooseLevel(.easy)
            viewModel.gameViewModel.guess("B")
            viewModel.goToCategories()
            viewModel.chooseCategory(.animals)
            viewModel.chooseLevel(.easy)
        }

        let animalsPuzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let animalsMaskedAnswer = await MainActor.run { viewModel.gameViewModel.gameViewState?.maskedAnswer }

        #expect(animalsPuzzle?.guessedLetters == ["A"])
        #expect(animalsMaskedAnswer == "A _")

        await MainActor.run {
            viewModel.goToCategories()
            viewModel.chooseCategory(.foods)
            viewModel.chooseLevel(.easy)
        }

        let foodsPuzzle = await MainActor.run { viewModel.gameViewModel.puzzle }
        let foodsMaskedAnswer = await MainActor.run { viewModel.gameViewModel.gameViewState?.maskedAnswer }

        #expect(foodsPuzzle?.guessedLetters == ["B"])
        #expect(foodsMaskedAnswer == "_ B")
    }
}
