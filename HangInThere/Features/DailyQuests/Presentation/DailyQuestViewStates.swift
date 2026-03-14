//
//  DailyQuestViewStates.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import Foundation

struct DailyQuestItemViewState: Identifiable {
    let kind: DailyQuestKind
    let title: String
    let progressText: String
    let rewardText: String
    let isCompleted: Bool
    let isClaimed: Bool

    var id: DailyQuestKind { kind }
}

struct DailyQuestBonusViewState {
    let title: String
    let subtitle: String
    let rewardText: String
    let isUnlocked: Bool
    let isClaimed: Bool
}

struct DailyQuestMenuViewState {
    let title: String
    let subtitle: String
    let sundayBonusText: String?
    let quests: [DailyQuestItemViewState]
    let bonus: DailyQuestBonusViewState
}

