//
//  HangInThereApp.swift
//  HangInThere
//
//  Created by Rafael Plinio on 12/03/26.
//

import SwiftUI

@main
struct HangInThereApp: App {
    private let wordRepository: any WordRepository
    private let progressRepository: any ProgressRepository
    private let dailyQuestRepository: any DailyQuestRepository
    private let soundPlayer: any SoundPlaying
    private let hapticPlayer: any HapticPlaying

    init() {
        if ProcessInfo.processInfo.arguments.contains("UITesting") {
            wordRepository = InMemoryWordRepository(
                wordsByCategory: Dictionary(
                    uniqueKeysWithValues: HangmanCategory.allCases.map { category in
                        (
                            category,
                            [HangmanWord(answer: "CAT", hint: "Pet", difficulty: 1)]
                        )
                    }
                )
            )
            progressRepository = InMemoryProgressRepository()
            dailyQuestRepository = InMemoryDailyQuestRepository()
            soundPlayer = SilentSoundPlayer.shared
            hapticPlayer = SilentHapticPlayer.shared
        } else {
            wordRepository = InMemoryWordRepository.default
            progressRepository = UserDefaultsProgressRepository()
            dailyQuestRepository = UserDefaultsDailyQuestRepository()
            soundPlayer = SoundEffectPlayer.shared
            hapticPlayer = HapticFeedbackPlayer.shared
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView(
                wordRepository: wordRepository,
                progressRepository: progressRepository,
                dailyQuestRepository: dailyQuestRepository,
                soundPlayer: soundPlayer,
                hapticPlayer: hapticPlayer
            )
        }
    }
}
