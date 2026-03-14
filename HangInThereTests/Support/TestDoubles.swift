//
//  TestDoubles.swift
//  HangInThereTests
//
//  Created by Codex on 12/03/26.
//

@testable import HangInThere

struct StubWordRepository: WordRepository {
    let word: HangmanWord

    func randomWord(for category: HangmanCategory, level: GameLevel) -> HangmanWord {
        word
    }
}

final class StubProgressRepository: ProgressRepository {
    var storedProgress: PlayerProgress

    init(storedProgress: PlayerProgress = PlayerProgress()) {
        self.storedProgress = storedProgress
    }

    func loadProgress() -> PlayerProgress {
        storedProgress
    }

    func saveProgress(_ progress: PlayerProgress) {
        storedProgress = progress
    }
}

final class StubDailyQuestRepository: DailyQuestRepository {
    var storedState: DailyQuestState?

    init(storedState: DailyQuestState? = nil) {
        self.storedState = storedState
    }

    func loadState() -> DailyQuestState? {
        storedState
    }

    func saveState(_ state: DailyQuestState) {
        storedState = state
    }
}
