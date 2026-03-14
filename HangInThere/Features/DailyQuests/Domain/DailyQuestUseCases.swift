//
//  DailyQuestUseCases.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import Foundation

struct GenerateDailyQuestStateUseCase {
    let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func execute(for date: Date) -> DailyQuestState {
        let easyPool: [DailyQuestKind] = [
            .playThreeRounds,
            .winOneRound,
            .earnHundredXP,
            .useOnePowerUp,
            .guessTenCorrectLetters
        ]
        let mediumPool: [DailyQuestKind] = [
            .winThreeRounds,
            .earnTwoHundredXP,
            .winOneMediumRound,
            .playTwoCategories,
            .finishRoundWithThreeLives
        ]
        let challengePool: [DailyQuestKind] = [
            .winOneHardRound,
            .solveRoundWithoutPowers,
            .playThreeCategories,
            .winTwoRoundsInARow
        ]

        let dayIndex = max(0, (calendar.ordinality(of: .day, in: .year, for: date) ?? 1) - 1)
        let easy = easyPool[dayIndex % easyPool.count]
        let medium = mediumPool[(dayIndex * 2 + 1) % mediumPool.count]
        let challenge = challengePool[(dayIndex * 3 + 2) % challengePool.count]

        let isSunday = calendar.component(.weekday, from: date) == 1

        return DailyQuestState(
            generatedOn: calendar.startOfDay(for: date),
            quests: [easy, medium, challenge].map {
                DailyQuest(kind: $0, rewardXP: rewardXP(for: $0.difficulty, isSunday: isSunday))
            },
            completionBonusXP: completionBonusXP(isSunday: isSunday)
        )
    }

    private func rewardXP(for difficulty: DailyQuestDifficulty, isSunday: Bool) -> Int {
        if isSunday {
            return difficulty.baseRewardXP * 3 / 2
        }
        return difficulty.baseRewardXP
    }

    private func completionBonusXP(isSunday: Bool) -> Int {
        if isSunday {
            return DailyQuestState.completionBonusBaseXP * 3 / 2
        }
        return DailyQuestState.completionBonusBaseXP
    }
}

struct RefreshDailyQuestStateUseCase {
    let calendar: Calendar
    let generator: GenerateDailyQuestStateUseCase

    init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.generator = GenerateDailyQuestStateUseCase(calendar: calendar)
    }

    func execute(existingState: DailyQuestState?, on date: Date) -> DailyQuestState {
        guard let existingState else {
            return generator.execute(for: date)
        }

        if calendar.isDate(existingState.generatedOn, inSameDayAs: date) {
            return existingState
        }

        return generator.execute(for: date)
    }
}

struct TrackDailyQuestEventUseCase {
    func execute(state: DailyQuestState, event: DailyQuestEvent) -> DailyQuestState {
        var updatedState = state

        switch event {
        case .roundStarted(let category):
            updatedState.stats.roundsPlayed += 1
            updatedState.stats.categoriesPlayed.insert(category)

        case .correctGuess:
            updatedState.stats.correctLettersGuessed += 1

        case .powerUpUsed:
            updatedState.stats.powerUpsUsed += 1

        case .roundWon(let level, let reward, let remainingLives, let usedPowerUp):
            updatedState.stats.roundsWon += 1
            updatedState.stats.roundExperienceEarned += reward
            updatedState.stats.currentWinStreak += 1
            updatedState.stats.highestWinStreak = max(
                updatedState.stats.highestWinStreak,
                updatedState.stats.currentWinStreak
            )

            if level == .medium {
                updatedState.stats.mediumWins += 1
            }

            if level == .hard {
                updatedState.stats.hardWins += 1
            }

            if !usedPowerUp {
                updatedState.stats.roundsWonWithoutPowers += 1
            }

            if remainingLives >= 3 {
                updatedState.stats.roundsWonWithThreeOrMoreLives += 1
            }

        case .roundLost:
            updatedState.stats.currentWinStreak = 0
        }

        for index in updatedState.quests.indices {
            let kind = updatedState.quests[index].kind
            updatedState.quests[index].progress = min(kind.goal, kind.progressValue(from: updatedState.stats))
        }

        return updatedState
    }
}

struct ClaimDailyQuestRewardUseCase {
    private let awardProgressUseCase: AwardProgressUseCase

    init(awardProgressUseCase: AwardProgressUseCase = AwardProgressUseCase()) {
        self.awardProgressUseCase = awardProgressUseCase
    }

    func execute(state: DailyQuestState, kind: DailyQuestKind, progress: PlayerProgress) -> DailyQuestClaimResult? {
        guard
            let index = state.quests.firstIndex(where: { $0.kind == kind }),
            state.quests[index].isCompleted,
            !state.quests[index].isClaimed
        else {
            return nil
        }

        var updatedState = state
        updatedState.quests[index].isClaimed = true
        let reward = updatedState.quests[index].rewardXP
        let award = awardProgressUseCase.execute(progress: progress, reward: reward)

        return DailyQuestClaimResult(
            state: updatedState,
            progress: award.progress,
            rewardXP: reward,
            levelsGained: award.levelsGained
        )
    }
}

struct ClaimDailyQuestCompletionBonusUseCase {
    private let awardProgressUseCase: AwardProgressUseCase

    init(awardProgressUseCase: AwardProgressUseCase = AwardProgressUseCase()) {
        self.awardProgressUseCase = awardProgressUseCase
    }

    func execute(state: DailyQuestState, progress: PlayerProgress) -> DailyQuestClaimResult? {
        guard state.allQuestsCompleted, !state.isCompletionBonusClaimed else { return nil }

        var updatedState = state
        updatedState.isCompletionBonusClaimed = true
        let reward = updatedState.completionBonusXP
        let award = awardProgressUseCase.execute(progress: progress, reward: reward)

        return DailyQuestClaimResult(
            state: updatedState,
            progress: award.progress,
            rewardXP: reward,
            levelsGained: award.levelsGained
        )
    }
}

struct DailyQuestClaimResult {
    let state: DailyQuestState
    let progress: PlayerProgress
    let rewardXP: Int
    let levelsGained: Int
}

