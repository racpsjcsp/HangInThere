//
//  DailyQuestRepository.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import Foundation

protocol DailyQuestRepository {
    func loadState() -> DailyQuestState?
    func saveState(_ state: DailyQuestState)
}

final class InMemoryDailyQuestRepository: DailyQuestRepository {
    private var state: DailyQuestState?

    init(state: DailyQuestState? = nil) {
        self.state = state
    }

    func loadState() -> DailyQuestState? {
        state
    }

    func saveState(_ state: DailyQuestState) {
        self.state = state
    }
}

struct UserDefaultsDailyQuestRepository: DailyQuestRepository {
    private let userDefaults: UserDefaults
    private let storageKey = "daily_quest_state"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadState() -> DailyQuestState? {
        guard
            let data = userDefaults.data(forKey: storageKey),
            let state = try? JSONDecoder().decode(DailyQuestState.self, from: data)
        else {
            return nil
        }

        return state
    }

    func saveState(_ state: DailyQuestState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}

