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
