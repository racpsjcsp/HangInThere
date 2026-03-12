//
//  ProgressRepository.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

protocol ProgressRepository {
    func loadProgress() -> PlayerProgress
    func saveProgress(_ progress: PlayerProgress)
}

final class InMemoryProgressRepository: ProgressRepository {
    private var progress: PlayerProgress

    init(progress: PlayerProgress = PlayerProgress()) {
        self.progress = progress
    }

    func loadProgress() -> PlayerProgress {
        progress
    }

    func saveProgress(_ progress: PlayerProgress) {
        self.progress = progress
    }
}

struct UserDefaultsProgressRepository: ProgressRepository {
    private let userDefaults: UserDefaults
    private let storageKey = "player_progress"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadProgress() -> PlayerProgress {
        guard
            let data = userDefaults.data(forKey: storageKey),
            let progress = try? JSONDecoder().decode(PlayerProgress.self, from: data)
        else {
            return PlayerProgress()
        }

        return progress
    }

    func saveProgress(_ progress: PlayerProgress) {
        guard let data = try? JSONEncoder().encode(progress) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
