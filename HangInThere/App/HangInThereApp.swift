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
        } else {
            wordRepository = InMemoryWordRepository.default
            progressRepository = UserDefaultsProgressRepository()
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView(
                wordRepository: wordRepository,
                progressRepository: progressRepository
            )
        }
    }
}
