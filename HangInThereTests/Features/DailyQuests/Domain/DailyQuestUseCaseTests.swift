//
//  DailyQuestUseCaseTests.swift
//  HangInThereTests
//
//  Created by Codex on 13/03/26.
//

import Foundation
import Testing
@testable import HangInThere

struct DailyQuestUseCaseTests {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func date(year: Int, month: Int, day: Int) -> Date {
        calendar.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: year, month: month, day: day))!
    }

    @Test func sundayGenerationAppliesWholeNumberBonusRewards() async throws {
        let useCase = GenerateDailyQuestStateUseCase(calendar: calendar)
        let date = date(year: 2026, month: 3, day: 15)

        let state = useCase.execute(for: date)

        #expect(state.isSundayBonus)
        #expect(state.completionBonusXP == 300)
        #expect(state.quests.map(\.rewardXP).contains(75))
        #expect(state.quests.map(\.rewardXP).contains(150))
        #expect(state.quests.map(\.rewardXP).contains(225))
    }

    @Test func refreshRegeneratesQuestStateWhenDayChanges() async throws {
        let useCase = RefreshDailyQuestStateUseCase(calendar: calendar)
        let firstDate = date(year: 2026, month: 3, day: 13)
        let secondDate = date(year: 2026, month: 3, day: 14)
        let originalState = GenerateDailyQuestStateUseCase(calendar: calendar).execute(for: firstDate)

        let refreshed = useCase.execute(existingState: originalState, on: secondDate)

        #expect(refreshed.generatedOn != originalState.generatedOn)
        #expect(refreshed.quests.map(\.kind) != originalState.quests.map(\.kind))
    }

    @Test func refreshKeepsExistingQuestStateWithinSameDay() async throws {
        let useCase = RefreshDailyQuestStateUseCase(calendar: calendar)
        let sameDay = date(year: 2026, month: 3, day: 13)
        var originalState = GenerateDailyQuestStateUseCase(calendar: calendar).execute(for: sameDay)
        originalState.quests[0].progress = 1
        originalState.quests[0].isClaimed = true

        let refreshed = useCase.execute(existingState: originalState, on: sameDay.addingTimeInterval(60 * 60 * 6))

        #expect(refreshed == originalState)
    }

    @Test func trackingEventsCompletesRelevantQuests() async throws {
        let state = DailyQuestState(
            generatedOn: Date(),
            quests: [
                DailyQuest(kind: .playThreeRounds, rewardXP: 50),
                DailyQuest(kind: .guessTenCorrectLetters, rewardXP: 50),
                DailyQuest(kind: .winTwoRoundsInARow, rewardXP: 150)
            ],
            completionBonusXP: 200
        )
        let useCase = TrackDailyQuestEventUseCase()

        var updated = state
        updated = useCase.execute(state: updated, event: .roundStarted(category: .animals))
        updated = useCase.execute(state: updated, event: .roundStarted(category: .foods))
        updated = useCase.execute(state: updated, event: .roundStarted(category: .objects))
        for _ in 0..<10 {
            updated = useCase.execute(state: updated, event: .correctGuess)
        }
        updated = useCase.execute(state: updated, event: .roundWon(level: .hard, reward: 60, remainingLives: 4, usedPowerUp: false))
        updated = useCase.execute(state: updated, event: .roundWon(level: .hard, reward: 60, remainingLives: 4, usedPowerUp: false))

        #expect(updated.quests.first(where: { $0.kind == .playThreeRounds })?.isCompleted == true)
        #expect(updated.quests.first(where: { $0.kind == .guessTenCorrectLetters })?.progress == 10)
        #expect(updated.quests.first(where: { $0.kind == .winTwoRoundsInARow })?.isCompleted == true)
    }

    @Test func trackingRoundLostResetsCurrentWinStreakButPreservesHighestStreak() async throws {
        let useCase = TrackDailyQuestEventUseCase()
        let state = DailyQuestState(
            generatedOn: Date(),
            quests: [DailyQuest(kind: .winTwoRoundsInARow, rewardXP: 150)],
            stats: DailyQuestStats(currentWinStreak: 2, highestWinStreak: 2),
            completionBonusXP: 200
        )

        let updated = useCase.execute(state: state, event: .roundLost)

        #expect(updated.stats.currentWinStreak == 0)
        #expect(updated.stats.highestWinStreak == 2)
        #expect(updated.quests.first?.progress == 2)
    }

    @Test func trackingEventsUpdatesEachQuestStatFromItsOwnSource() async throws {
        var updated = DailyQuestState(
            generatedOn: Date(),
            quests: [
                DailyQuest(kind: .useOnePowerUp, rewardXP: 50),
                DailyQuest(kind: .earnTwoHundredXP, rewardXP: 100),
                DailyQuest(kind: .winOneMediumRound, rewardXP: 100),
                DailyQuest(kind: .playTwoCategories, rewardXP: 100),
                DailyQuest(kind: .finishRoundWithThreeLives, rewardXP: 100),
                DailyQuest(kind: .winOneHardRound, rewardXP: 150),
                DailyQuest(kind: .solveRoundWithoutPowers, rewardXP: 150)
            ],
            completionBonusXP: 200
        )
        let useCase = TrackDailyQuestEventUseCase()

        updated = useCase.execute(state: updated, event: .roundStarted(category: .animals))
        updated = useCase.execute(state: updated, event: .roundStarted(category: .foods))
        updated = useCase.execute(state: updated, event: .powerUpUsed)
        updated = useCase.execute(state: updated, event: .roundWon(level: .medium, reward: 120, remainingLives: 4, usedPowerUp: true))
        updated = useCase.execute(state: updated, event: .roundWon(level: .hard, reward: 80, remainingLives: 4, usedPowerUp: false))

        #expect(updated.quests.first(where: { $0.kind == .useOnePowerUp })?.progress == 1)
        #expect(updated.quests.first(where: { $0.kind == .earnTwoHundredXP })?.progress == 200)
        #expect(updated.quests.first(where: { $0.kind == .winOneMediumRound })?.progress == 1)
        #expect(updated.quests.first(where: { $0.kind == .playTwoCategories })?.progress == 2)
        #expect(updated.quests.first(where: { $0.kind == .finishRoundWithThreeLives })?.progress == 1)
        #expect(updated.quests.first(where: { $0.kind == .winOneHardRound })?.progress == 1)
        #expect(updated.quests.first(where: { $0.kind == .solveRoundWithoutPowers })?.progress == 1)
    }

    @Test func claimQuestRewardMarksQuestClaimedAndAwardsExperience() async throws {
        let state = DailyQuestState(
            generatedOn: Date(),
            quests: [DailyQuest(kind: .winOneRound, progress: 1, isClaimed: false, rewardXP: 50)],
            completionBonusXP: 200
        )

        let result = ClaimDailyQuestRewardUseCase().execute(
            state: state,
            kind: .winOneRound,
            progress: PlayerProgress()
        )

        #expect(result?.rewardXP == 50)
        #expect(result?.state.quests.first?.isClaimed == true)
        #expect(result?.progress.experience == 50)
    }

    @Test func claimQuestRewardReturnsLevelsGainedWhenRewardCrossesThreshold() async throws {
        let state = DailyQuestState(
            generatedOn: Date(),
            quests: [DailyQuest(kind: .earnTwoHundredXP, progress: 200, isClaimed: false, rewardXP: 100)],
            completionBonusXP: 200
        )
        var progress = PlayerProgress()
        progress.experience = 79

        let result = ClaimDailyQuestRewardUseCase().execute(
            state: state,
            kind: .earnTwoHundredXP,
            progress: progress
        )

        #expect(result?.levelsGained == 1)
        #expect(result?.progress.level == 2)
    }

    @Test func claimCompletionBonusRequiresAllQuestsCompleted() async throws {
        let incompleteState = DailyQuestState(
            generatedOn: Date(),
            quests: [
                DailyQuest(kind: .playThreeRounds, progress: 3, isClaimed: true, rewardXP: 50),
                DailyQuest(kind: .winOneMediumRound, progress: 0, isClaimed: false, rewardXP: 100),
                DailyQuest(kind: .winOneHardRound, progress: 1, isClaimed: true, rewardXP: 150)
            ],
            completionBonusXP: 200
        )
        let completeState = DailyQuestState(
            generatedOn: Date(),
            quests: [
                DailyQuest(kind: .playThreeRounds, progress: 3, isClaimed: true, rewardXP: 50),
                DailyQuest(kind: .winOneMediumRound, progress: 1, isClaimed: true, rewardXP: 100),
                DailyQuest(kind: .winOneHardRound, progress: 1, isClaimed: true, rewardXP: 150)
            ],
            completionBonusXP: 200
        )

        let denied = ClaimDailyQuestCompletionBonusUseCase().execute(state: incompleteState, progress: PlayerProgress())
        let granted = ClaimDailyQuestCompletionBonusUseCase().execute(state: completeState, progress: PlayerProgress())

        #expect(denied == nil)
        #expect(granted?.rewardXP == 200)
        #expect(granted?.state.isCompletionBonusClaimed == true)
    }
}
