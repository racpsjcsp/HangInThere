//
//  PlayerProgressTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

struct PlayerProgressTests {
    @Test func progressStartsWithoutPowerCharges() async throws {
        let progress = PlayerProgress()

        #expect(progress.revealLetterCharges == 0)
        #expect(progress.freeGuessCharges == 0)
    }

    @Test func progressUnlocksPowerChargesAtLevelThree() async throws {
        var progress = PlayerProgress()

        let levelsGained = progress.awardExperience(200)

        #expect(levelsGained == 2)
        #expect(progress.level == 3)
        #expect(progress.revealLetterCharges == 1)
        #expect(progress.freeGuessCharges == 1)
    }

    @Test func progressAwardsMostlyFreeGuessAtMilestones() async throws {
        var progress = PlayerProgress()

        _ = progress.awardExperience(560)

        #expect(progress.level == 5)
        #expect(progress.revealLetterCharges == 1)
        #expect(progress.freeGuessCharges == 1)

        _ = progress.awardExperience(240)

        #expect(progress.level == 6)
        #expect(progress.revealLetterCharges == 1)
        #expect(progress.freeGuessCharges == 2)
    }

    @Test func progressCapsChargesAtTwo() async throws {
        var progress = PlayerProgress()

        _ = progress.awardExperience(1_760)

        #expect(progress.level >= 9)
        #expect(progress.revealLetterCharges == PlayerProgress.maxPowerCharges)
        #expect(progress.freeGuessCharges == PlayerProgress.maxPowerCharges)
    }
}
