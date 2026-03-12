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

        let result = AwardProgressUseCase().execute(progress: progress, reward: 200)

        #expect(result.levelsGained == 2)
        #expect(result.progress.level == 3)
        #expect(result.progress.revealLetterCharges == 1)
        #expect(result.progress.freeGuessCharges == 1)
    }

    @Test func awardProgressAppliesMilestoneRewardsWithCaps() async throws {
        let progress = PlayerProgress()

        let result = AwardProgressUseCase().execute(progress: progress, reward: 1_760)

        #expect(result.progress.level >= 9)
        #expect(result.progress.revealLetterCharges == PlayerProgress.maxPowerCharges)
        #expect(result.progress.freeGuessCharges == PlayerProgress.maxPowerCharges)
    }
}
