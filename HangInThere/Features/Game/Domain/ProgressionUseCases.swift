//
//  ProgressionUseCases.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

struct SpendPowerChargeUseCase {
    func execute(progress: PlayerProgress, powerUp: PowerUp) -> PlayerProgress? {
        var updatedProgress = progress

        switch powerUp {
        case .revealLetter:
            guard updatedProgress.revealLetterCharges > 0 else { return nil }
            updatedProgress.revealLetterCharges -= 1

        case .freeGuess:
            guard updatedProgress.freeGuessCharges > 0 else { return nil }
            updatedProgress.freeGuessCharges -= 1
        }

        return updatedProgress
    }
}

struct AwardProgressUseCase {
    func execute(progress: PlayerProgress, reward: Int) -> ProgressAwardResult {
        var updatedProgress = progress
        let previousRevealCharges = updatedProgress.revealLetterCharges
        let previousFreeGuessCharges = updatedProgress.freeGuessCharges
        let levelsGained = updatedProgress.awardExperience(reward)

        return ProgressAwardResult(
            progress: updatedProgress,
            levelsGained: levelsGained,
            revealChargesGained: updatedProgress.revealLetterCharges - previousRevealCharges,
            freeGuessChargesGained: updatedProgress.freeGuessCharges - previousFreeGuessCharges
        )
    }
}

struct ProgressAwardResult {
    let progress: PlayerProgress
    let levelsGained: Int
    let revealChargesGained: Int
    let freeGuessChargesGained: Int
}
