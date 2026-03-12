//
//  PlayerProgressTests.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

import Testing
@testable import HangInThere

struct PlayerProgressTests {
    @Test func progressLevelsUpAndGrantsCharges() async throws {
        var progress = PlayerProgress()

        let levelsGained = progress.awardExperience(140)

        #expect(levelsGained == 1)
        #expect(progress.level == 2)
        #expect(progress.revealLetterCharges == 3)
        #expect(progress.freeGuessCharges == 2)
    }
}
