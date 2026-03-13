//
//  GameplayUseCaseTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

struct GameplayUseCaseTests {
    @Test func startRoundBuildsPuzzleFromRepository() async throws {
        let expectedWord = HangmanWord(answer: "Repository", hint: "Comes from data source", difficulty: 3)
        let useCase = StartRoundUseCase(wordRepository: StubWordRepository(word: expectedWord))

        let puzzle = useCase.execute(category: .geography, level: .hard)

        #expect(puzzle.category == .geography)
        #expect(puzzle.word == expectedWord)
    }

    @Test func startRoundUsesSelectedLevelWordPool() async throws {
        let easyWord = HangmanWord(answer: "Fox", hint: "Easy animal", difficulty: 1)
        let mediumWord = HangmanWord(answer: "Caracal", hint: "Medium animal", difficulty: 2)
        let hardWord = HangmanWord(answer: "Cassowary", hint: "Hard animal", difficulty: 3)
        let repository = InMemoryWordRepository(
            wordsByCategoryAndLevel: [
                .animals: [
                    .easy: [easyWord],
                    .medium: [mediumWord],
                    .hard: [hardWord]
                ]
            ]
        )
        let useCase = StartRoundUseCase(wordRepository: repository)

        let easyPuzzle = useCase.execute(category: .animals, level: .easy)
        let mediumPuzzle = useCase.execute(category: .animals, level: .medium)
        let hardPuzzle = useCase.execute(category: .animals, level: .hard)

        #expect(easyPuzzle.word == easyWord)
        #expect(mediumPuzzle.word == mediumWord)
        #expect(hardPuzzle.word == hardWord)
    }

    @Test func repositoryDoesNotRepeatWordsUntilPoolIsExhausted() async throws {
        let firstWord = HangmanWord(answer: "Pizza", hint: "Easy food", difficulty: 1)
        let secondWord = HangmanWord(answer: "Burger", hint: "Another easy food", difficulty: 1)
        let repository = InMemoryWordRepository(
            wordsByCategoryAndLevel: [
                .foods: [
                    .easy: [firstWord, secondWord]
                ]
            ]
        )

        let pulledAnswers = Set([
            repository.randomWord(for: .foods, level: .easy).answer,
            repository.randomWord(for: .foods, level: .easy).answer
        ])

        #expect(pulledAnswers == Set([firstWord.answer, secondWord.answer]))
    }

    @Test func resolveRoundStateAwardsExperienceForWins() async throws {
        let puzzle = HangmanPuzzle(
            category: .animals,
            word: HangmanWord(answer: "A", hint: "Letter", difficulty: 1),
            guessedLetters: ["A"],
            wrongGuesses: 1
        )
        let progress = PlayerProgress()

        let result = ResolveRoundStateUseCase().execute(
            puzzle: puzzle,
            progress: progress,
            previousWrongGuesses: 1
        )

        guard case .won(_, let updatedProgress, let reward, _) = result else {
            Issue.record("Expected a win resolution")
            return
        }

        #expect(reward > 0)
        #expect(updatedProgress.experience == reward)
    }
}
