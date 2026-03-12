//
//  ProgressionUseCaseTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

struct ProgressionUseCaseTests {
    @Test func spendPowerChargeConsumesOnlyRequestedCharge() async throws {
        let progress = PlayerProgress(
            level: 1,
            experience: 0,
            revealLetterCharges: 2,
            freeGuessCharges: 1
        )

        let updatedProgress = SpendPowerChargeUseCase().execute(
            progress: progress,
            powerUp: .revealLetter
        )

        #expect(updatedProgress?.revealLetterCharges == 1)
        #expect(updatedProgress?.freeGuessCharges == 1)
    }

    @Test func awardProgressReturnsUpdatedProgressAndLevelsGained() async throws {
        let progress = PlayerProgress()

        let result = AwardProgressUseCase().execute(progress: progress, reward: 140)

        #expect(result.levelsGained == 1)
        #expect(result.progress.level == 2)
        #expect(result.progress.revealLetterCharges == 3)
        #expect(result.progress.freeGuessCharges == 2)
    }
}
