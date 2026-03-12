//
//  HangmanPuzzleTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

struct HangmanPuzzleTests {
    @Test func revealPowerRevealsALetter() async throws {
        var puzzle = HangmanPuzzle(
            category: .animals,
            word: HangmanWord(answer: "Cat", hint: "Pet", difficulty: 1)
        )

        let revealed = puzzle.useRevealPower()

        #expect(revealed != nil)
        #expect(puzzle.guessedLetters.count == 1)
        #expect(puzzle.maskedAnswer.contains(String(revealed!)))
    }

    @Test func freeGuessPreventsNextPenalty() async throws {
        var puzzle = HangmanPuzzle(
            category: .objects,
            word: HangmanWord(answer: "Lamp", hint: "Light source", difficulty: 1)
        )

        let didActivate = puzzle.useFreeGuessShield()
        puzzle.guess("Z")

        #expect(didActivate)
        #expect(puzzle.wrongGuesses == 0)
        #expect(puzzle.freeGuessShield == false)
    }
}
