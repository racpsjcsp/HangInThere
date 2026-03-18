//
//  HangmanGameViewModel.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HangmanGameViewModel: ObservableObject {
    private struct SuspendedRoundKey: Hashable {
        let category: HangmanCategory
        let level: GameLevel
    }

    private struct SuspendedRound {
        let puzzle: HangmanPuzzle
        let usedPowerUp: Bool
    }

    @Published private(set) var progress = PlayerProgress()
    @Published private(set) var selectedCategory: HangmanCategory?
    @Published private(set) var selectedLevel: GameLevel?
    @Published private(set) var puzzle: HangmanPuzzle?
    @Published private(set) var dailyQuestState: DailyQuestState
    @Published private(set) var message = Strings.Message.initial
    @Published private(set) var lastAwardedXP: Int = 0
    @Published private(set) var lastLevelsGained: Int = 0
    @Published private(set) var lastRevealChargesGained: Int = 0
    @Published private(set) var lastFreeGuessChargesGained: Int = 0
    @Published private(set) var roundPhase: RoundPhase = .playing

    private let startRoundUseCase: StartRoundUseCase
    private let progressRepository: any ProgressRepository
    private let dailyQuestRepository: any DailyQuestRepository
    private let soundPlayer: any SoundPlaying
    private let hapticPlayer: any HapticPlaying
    private let refreshDailyQuestStateUseCase: RefreshDailyQuestStateUseCase
    private let trackDailyQuestEventUseCase = TrackDailyQuestEventUseCase()
    private let claimDailyQuestRewardUseCase = ClaimDailyQuestRewardUseCase()
    private let claimDailyQuestCompletionBonusUseCase = ClaimDailyQuestCompletionBonusUseCase()
    private let dateProvider: () -> Date
    private let guessLetterUseCase = GuessLetterUseCase()
    private let usePowerUpUseCase = UsePowerUpUseCase()
    private let resolveRoundStateUseCase = ResolveRoundStateUseCase()
    private var currentRoundUsedPowerUp = false
    private var suspendedRounds: [SuspendedRoundKey: SuspendedRound] = [:]

    convenience init() {
        self.init(
            wordRepository: InMemoryWordRepository.default,
            progressRepository: UserDefaultsProgressRepository(),
            dailyQuestRepository: UserDefaultsDailyQuestRepository(),
            soundPlayer: SoundEffectPlayer.shared,
            hapticPlayer: HapticFeedbackPlayer.shared
        )
    }

    init(
        wordRepository: any WordRepository,
        progressRepository: any ProgressRepository,
        dailyQuestRepository: any DailyQuestRepository = InMemoryDailyQuestRepository(),
        calendar: Calendar = .current,
        dateProvider: @escaping () -> Date = Date.init,
        soundPlayer: (any SoundPlaying)? = nil,
        hapticPlayer: (any HapticPlaying)? = nil
    ) {
        let resolvedSoundPlayer = soundPlayer ?? SilentSoundPlayer.shared
        let resolvedHapticPlayer = hapticPlayer ?? SilentHapticPlayer.shared
        self.startRoundUseCase = StartRoundUseCase(wordRepository: wordRepository)
        self.progressRepository = progressRepository
        self.dailyQuestRepository = dailyQuestRepository
        self.soundPlayer = resolvedSoundPlayer
        self.hapticPlayer = resolvedHapticPlayer
        self.refreshDailyQuestStateUseCase = RefreshDailyQuestStateUseCase(calendar: calendar)
        self.dateProvider = dateProvider
        let loadedProgress = progressRepository.loadProgress()
        self.progress = loadedProgress
        self.dailyQuestState = refreshDailyQuestStateUseCase.execute(
            existingState: dailyQuestRepository.loadState(),
            on: dateProvider(),
            progress: loadedProgress
        )
        dailyQuestRepository.saveState(dailyQuestState)
    }

    var keyboardRows: [[String]] {
        [
            Array(Strings.Game.keyboardTopRow).map(String.init),
            Array(Strings.Game.keyboardMiddleRow).map(String.init),
            Array(Strings.Game.keyboardBottomRow).map(String.init)
        ]
    }

    var categorySelectionViewState: CategorySelectionViewState {
        CategorySelectionViewState(
            title: Strings.Selection.title,
            message: message,
            progressTitle: Strings.Selection.progressTitle,
            levelText: Strings.Selection.level(progress.level),
            progressValue: progress.progressToNextLevel,
            nextRewardText: Strings.Selection.nextReward(nextPowerRewardText),
            revealTitle: Strings.Selection.revealStat,
            revealValue: "\(progress.revealLetterCharges)",
            freeGuessTitle: Strings.Selection.freeGuessStat,
            freeGuessValue: "\(progress.freeGuessCharges)",
            dailyQuestsTitle: Strings.Selection.dailyQuestsTitle,
            dailyQuestsSummary: Strings.DailyQuests.categorySummary(dailyQuestState.completedQuestCount, dailyQuestState.quests.count),
            dailyQuestsButtonTitle: Strings.Selection.openDailyQuests,
            settingsButtonTitle: Strings.Selection.openSettings,
            categories: HangmanCategory.allCases.map { category in
                CategoryCardViewState(
                    category: category,
                    title: category.title,
                    description: description(for: category),
                    imageName: category.assetName
                )
            }
        )
    }

    var dailyQuestMenuViewState: DailyQuestMenuViewState {
        return DailyQuestMenuViewState(
            title: Strings.DailyQuests.title,
            subtitle: Strings.DailyQuests.subtitle(dailyQuestState.completedQuestCount, dailyQuestState.quests.count),
            playerLevelText: Strings.Selection.level(progress.level),
            experienceText: Strings.DailyQuests.experience(
                progress.experienceWithinCurrentLevel,
                progress.experienceRequiredForCurrentLevel
            ),
            progressValue: progress.progressToNextLevel,
            sundayBonusText: dailyQuestState.isSundayBonus ? Strings.DailyQuests.sundayBonus : nil,
            quests: dailyQuestState.quests.map { quest in
                DailyQuestItemViewState(
                    kind: quest.kind,
                    title: Strings.DailyQuests.questTitle(quest.kind),
                    progressText: Strings.DailyQuests.progress(quest.progress, quest.kind.goal),
                    rewardText: Strings.DailyQuests.reward(quest.rewardXP),
                    isCompleted: quest.isCompleted,
                    isClaimed: quest.isClaimed
                )
            },
            bonus: DailyQuestBonusViewState(
                title: Strings.DailyQuests.completionBonusTitle,
                subtitle: Strings.DailyQuests.completionBonusSubtitle,
                rewardText: Strings.DailyQuests.reward(dailyQuestState.completionBonusXP),
                isUnlocked: dailyQuestState.allQuestsCompleted,
                isClaimed: dailyQuestState.isCompletionBonusClaimed
            )
        )
    }

    var settingsMenuViewState: SettingsMenuViewState {
        SettingsMenuViewState(
            title: Strings.Settings.title,
            subtitle: Strings.Settings.subtitle,
            soundEnabled: soundPlayer.isSoundEnabled,
            hapticsEnabled: hapticPlayer.isHapticsEnabled,
            playerLevelText: Strings.Selection.level(progress.level),
            progressText: Strings.DailyQuests.experience(
                progress.experienceWithinCurrentLevel,
                progress.experienceRequiredForCurrentLevel
            ),
            nextRewardText: Strings.Selection.nextReward(nextPowerRewardText),
            storageNote: Strings.Settings.localStorageNote
        )
    }

    var gameViewState: GameViewState? {
        guard let puzzle, let selectedLevel else { return nil }

        let summary: SummaryViewState?
        if roundPhase == .summary {
            let isWin = puzzle.status == .won
            summary = SummaryViewState(
                isWin: isWin,
                title: isWin ? Strings.Game.wonTitle : Strings.Game.lostTitle,
                subtitle: isWin
                    ? Strings.Game.wonSubtitle(lastAwardedXP)
                    : Strings.Game.lostSubtitle(puzzle.answer),
                symbol: isWin ? Strings.Symbol.winSummary : Strings.Symbol.lossSummary,
                tint: isWin ? AppTheme.success : AppTheme.accent,
                levelUpTitle: isWin && lastLevelsGained > 0 ? Strings.Game.levelUpTitle : nil,
                levelUpSubtitle: isWin && lastLevelsGained > 0
                    ? Strings.Game.levelUpSubtitle(progress.level, levelsGained: lastLevelsGained)
                    : nil,
                powerRewardTitle: isWin && (lastRevealChargesGained > 0 || lastFreeGuessChargesGained > 0)
                    ? Strings.Game.powerRewardTitle
                    : nil,
                powerRewardSubtitle: isWin && (lastRevealChargesGained > 0 || lastFreeGuessChargesGained > 0)
                    ? Strings.Game.powerRewardSubtitle(
                        revealCharges: lastRevealChargesGained,
                        freeGuessCharges: lastFreeGuessChargesGained
                    )
                    : nil
            )
        } else {
            summary = nil
        }

        return GameViewState(
            categoryTitle: puzzle.category.title,
            categoryTint: puzzle.category.tint,
            gameLevelTitle: selectedLevel.title,
            gameLevelTint: selectedLevel.tint,
            categoriesButtonTitle: Strings.Game.categories,
            playerLevelText: Strings.Selection.level(progress.level),
            hangmanStage: puzzle.wrongGuesses,
            maskedAnswer: puzzle.maskedAnswer,
            hintTitle: Strings.Game.hint,
            hintText: puzzle.hint,
            livesTitle: Strings.Game.lives,
            livesValue: "\(puzzle.remainingLives)",
            wrongTitle: Strings.Game.wrong,
            wrongGuessCount: puzzle.wrongGuesses,
            wrongValue: puzzle.incorrectLetters.joined(separator: " ").ifEmpty(Strings.Game.none),
            showFreeGuessActive: puzzle.freeGuessShield,
            freeGuessActiveText: Strings.Game.freeGuessActive,
            message: message,
            revealPowerTitle: Strings.Power.revealTitle,
            revealPowerCharges: progress.revealLetterCharges,
            revealButtonImageName: PowerUp.revealLetter.assetName,
            freeGuessPowerTitle: Strings.Power.freeGuessTitle,
            freeGuessPowerCharges: progress.freeGuessCharges,
            freeGuessButtonImageName: PowerUp.freeGuess.assetName,
            keyboardRows: keyboardRows,
            guessedLetters: Set(puzzle.guessedLetters.map { String($0) }),
            isPlaying: puzzle.status == .playing,
            summary: summary
        )
    }

    var levelSelectionViewState: GameLevelSelectionViewState? {
        guard let selectedCategory else { return nil }

        return GameLevelSelectionViewState(
            title: Strings.LevelSelection.title,
            categoryTitle: selectedCategory.title,
            categoryTint: selectedCategory.tint,
            backButtonTitle: Strings.LevelSelection.back,
            levels: GameLevel.allCases.map { level in
                LevelOptionViewState(
                    level: level,
                    title: level.title,
                    description: level.description,
                    imageName: level.assetName,
                    imageScale: level.assetScale,
                    resumeText: hasSuspendedRound(for: selectedCategory, level: level)
                        ? Strings.LevelSelection.resume
                        : nil
                )
            }
        )
    }

    var currentCategory: HangmanCategory? {
        selectedCategory
    }

    var currentLevel: GameLevel? {
        selectedLevel
    }

    var isSoundEnabled: Bool {
        soundPlayer.isSoundEnabled
    }

    var isHapticsEnabled: Bool {
        hapticPlayer.isHapticsEnabled
    }

    func hasSuspendedRound(for category: HangmanCategory, level: GameLevel) -> Bool {
        suspendedRounds[.init(category: category, level: level)] != nil
    }

    func discardSuspendedRound(for category: HangmanCategory, level: GameLevel) {
        suspendedRounds.removeValue(forKey: .init(category: category, level: level))
    }

    func showCategorySelection(message: String, preservingCurrentRound: Bool = false) {
        refreshDailyQuestsIfNeeded()
        if preservingCurrentRound,
           roundPhase == .playing,
           let selectedCategory,
           let selectedLevel,
           let puzzle {
            suspendedRounds[.init(category: selectedCategory, level: selectedLevel)] = SuspendedRound(
                puzzle: puzzle,
                usedPowerUp: currentRoundUsedPowerUp
            )
        }
        withAnimation(AppTheme.Motion.screenTransition) {
            roundPhase = .playing
            selectedCategory = nil
            selectedLevel = nil
            puzzle = nil
            self.message = message
        }
    }

    func selectCategory(_ category: HangmanCategory) {
        refreshDailyQuestsIfNeeded()
        withAnimation(AppTheme.Motion.screenTransition) {
            selectedCategory = category
            selectedLevel = nil
            puzzle = nil
            roundPhase = .playing
            message = Strings.LevelSelection.subtitle(category.title)
        }
    }

    func startRound(for category: HangmanCategory, level: GameLevel = .medium, resumeIfPossible: Bool = true) {
        selectedCategory = category
        selectedLevel = level
        let key = SuspendedRoundKey(category: category, level: level)
        if resumeIfPossible,
           let suspendedRound = suspendedRounds[key] {
            resumeRound(from: suspendedRound, for: key)
        } else {
            suspendedRounds.removeValue(forKey: key)
            startRound(in: category, level: level)
        }
    }

    func toggleSound() {
        setSoundEnabled(!soundPlayer.isSoundEnabled)
    }

    func setSoundEnabled(_ isEnabled: Bool) {
        guard soundPlayer.isSoundEnabled != isEnabled else { return }
        soundPlayer.isSoundEnabled = isEnabled
        if isEnabled {
            soundPlayer.play(.soundToggle)
        }
        hapticPlayer.toggle()
        objectWillChange.send()
    }

    func toggleHaptics() {
        setHapticsEnabled(!hapticPlayer.isHapticsEnabled)
    }

    func setHapticsEnabled(_ isEnabled: Bool) {
        guard hapticPlayer.isHapticsEnabled != isEnabled else { return }
        hapticPlayer.isHapticsEnabled = isEnabled
        if isEnabled {
            hapticPlayer.toggle()
        }
        objectWillChange.send()
    }

    func guess(_ letter: String) {
        guard let puzzle, let result = guessLetterUseCase.execute(puzzle: puzzle, letter: letter) else { return }
        let guessedCorrectly = result.puzzle.wrongGuesses == result.previousWrongGuesses && result.puzzle.guessedLetters.count > puzzle.guessedLetters.count
        withAnimation(AppTheme.Motion.cardBounce) {
            self.puzzle = result.puzzle
        }
        if guessedCorrectly {
            applyDailyQuestEvent(.correctGuess)
        }
        apply(resolveRoundStateUseCase.execute(
            puzzle: result.puzzle,
            progress: progress,
            previousWrongGuesses: result.previousWrongGuesses
        ))
    }

    func usePower(_ powerUp: PowerUp) {
        guard let puzzle else { return }

        switch usePowerUpUseCase.execute(puzzle: puzzle, progress: progress, powerUp: powerUp) {
        case .unavailable(let power):
            switch power {
            case .revealLetter:
                message = Strings.Message.noRevealCharges
            case .freeGuess:
                message = Strings.Message.noFreeGuessCharges
            }

        case .noEffect(let power):
            switch power {
            case .revealLetter:
                message = Strings.Message.nothingToReveal
            case .freeGuess:
                message = Strings.Message.freeGuessAlreadyActive
            }

        case .revealLetter(let puzzle, let progress, let revealed):
            self.puzzle = puzzle
            self.progress = progress
            persistProgress()
            currentRoundUsedPowerUp = true
            applyDailyQuestEvent(.powerUpUsed)
            message = Strings.Message.revealed(String(revealed))
            let resolution = resolveRoundStateUseCase.execute(
                puzzle: puzzle,
                progress: progress,
                previousWrongGuesses: puzzle.wrongGuesses
            )
            if case .playing = resolution {
                soundPlayer.play(.revealPower)
            }
            apply(resolution, triggeredByPowerUp: true)

        case .freeGuessShield(let puzzle, let progress):
            self.puzzle = puzzle
            self.progress = progress
            persistProgress()
            currentRoundUsedPowerUp = true
            applyDailyQuestEvent(.powerUpUsed)
            message = Strings.Message.freeGuessActivated
            soundPlayer.play(.freeGuessPower)
        }
    }

    func claimDailyQuest(_ kind: DailyQuestKind) {
        refreshDailyQuestsIfNeeded()
        guard let result = claimDailyQuestRewardUseCase.execute(state: dailyQuestState, kind: kind, progress: progress) else { return }
        dailyQuestState = result.state
        progress = result.progress
        message = Strings.Message.dailyQuestRewardClaimed(result.rewardXP)
        soundPlayer.play(.claimReward)
        persistProgress()
        persistDailyQuests()
    }

    func claimDailyQuestCompletionBonus() {
        refreshDailyQuestsIfNeeded()
        guard let result = claimDailyQuestCompletionBonusUseCase.execute(state: dailyQuestState, progress: progress) else { return }
        dailyQuestState = result.state
        progress = result.progress
        message = Strings.Message.dailyQuestBonusClaimed(result.rewardXP)
        soundPlayer.play(.claimReward)
        persistProgress()
        persistDailyQuests()
    }

    func isGuessed(_ letter: String) -> Bool {
        guard let character = letter.first, let puzzle else { return false }
        return puzzle.guessedLetters.contains(Character(String(character).uppercased()))
    }

    private func startRound(in category: HangmanCategory, level: GameLevel) {
        refreshDailyQuestsIfNeeded()
        suspendedRounds.removeValue(forKey: .init(category: category, level: level))
        let nextPuzzle = startRoundUseCase.execute(category: category, level: level)
        withAnimation(AppTheme.Motion.screenTransition) {
            puzzle = nextPuzzle
            roundPhase = .playing
            lastAwardedXP = 0
            lastLevelsGained = 0
            lastRevealChargesGained = 0
            lastFreeGuessChargesGained = 0
            message = Strings.Message.makeFirstGuess
        }
        currentRoundUsedPowerUp = false
        applyDailyQuestEvent(.roundStarted(category: category))
    }

    private func resumeRound(from suspendedRound: SuspendedRound, for key: SuspendedRoundKey) {
        withAnimation(AppTheme.Motion.screenTransition) {
            puzzle = suspendedRound.puzzle
            roundPhase = .playing
            lastAwardedXP = 0
            lastLevelsGained = 0
            lastRevealChargesGained = 0
            lastFreeGuessChargesGained = 0
            message = Strings.Message.resumedRound(selectedLevel?.title ?? Strings.Mode.mediumTitle)
        }
        currentRoundUsedPowerUp = suspendedRound.usedPowerUp
        suspendedRounds.removeValue(forKey: key)
    }

    private func apply(_ resolution: RoundResolution, triggeredByPowerUp: Bool = false) {
        switch resolution {
        case .playing(let wrongGuessesChanged, let freeGuessShield, let remainingLives):
            if !wrongGuessesChanged {
                message = freeGuessShield
                    ? Strings.Message.freeGuessReady
                    : Strings.Message.goodGuess
                if !triggeredByPowerUp {
                    soundPlayer.play(.correctGuess)
                }
            } else {
                message = Strings.Message.missed(remainingLives)
                soundPlayer.play(.wrongGuess)
            }

        case .won(let puzzle, let progress, let reward, let levelsGained, let revealChargesGained, let freeGuessChargesGained):
            withAnimation(AppTheme.Motion.summaryReveal) {
                self.puzzle = puzzle
                self.progress = progress
                lastAwardedXP = reward
                lastLevelsGained = levelsGained
                lastRevealChargesGained = revealChargesGained
                lastFreeGuessChargesGained = freeGuessChargesGained
                roundPhase = .summary
            }
            persistProgress()
            applyDailyQuestEvent(.roundWon(
                level: selectedLevel ?? .medium,
                reward: reward,
                remainingLives: puzzle.remainingLives,
                usedPowerUp: currentRoundUsedPowerUp
            ))
            message = levelsGained > 0
                ? Strings.Message.levelUp(progress.level)
                : Strings.Message.roundWon(reward)
            soundPlayer.play(levelsGained > 0 ? .levelUp : .winRound)

        case .lost(let puzzle):
            withAnimation(AppTheme.Motion.summaryReveal) {
                self.puzzle = puzzle
                roundPhase = .summary
            }
            lastAwardedXP = 0
            lastLevelsGained = 0
            lastRevealChargesGained = 0
            lastFreeGuessChargesGained = 0
            applyDailyQuestEvent(.roundLost)
            message = Strings.Message.roundLost(puzzle.answer)
            soundPlayer.play(.loseRound)
        }
    }

    private func description(for category: HangmanCategory) -> String {
        switch category {
        case .animals:
            Strings.Category.animalsDescription
        case .geography:
            Strings.Category.geographyDescription
        case .foods:
            Strings.Category.foodsDescription
        case .objects:
            Strings.Category.objectsDescription
        }
    }

    private func persistProgress() {
        progressRepository.saveProgress(progress)
    }

    func refreshDailyQuests() {
        refreshDailyQuestsIfNeeded()
    }

    private func refreshDailyQuestsIfNeeded() {
        let refreshedState = refreshDailyQuestStateUseCase.execute(
            existingState: dailyQuestState,
            on: dateProvider(),
            progress: progress
        )

        guard refreshedState != dailyQuestState else { return }
        dailyQuestState = refreshedState
        persistDailyQuests()
    }

    private func applyDailyQuestEvent(_ event: DailyQuestEvent) {
        refreshDailyQuestsIfNeeded()
        dailyQuestState = trackDailyQuestEventUseCase.execute(state: dailyQuestState, event: event)
        persistDailyQuests()
    }

    private func persistDailyQuests() {
        dailyQuestRepository.saveState(dailyQuestState)
    }

    private var nextPowerRewardText: String {
        let nextReward = progress.nextPowerReward
        return Strings.Game.nextPowerReward(
            level: nextReward.level,
            revealCharges: nextReward.revealCharges,
            freeGuessCharges: nextReward.freeGuessCharges
        )
    }
}

private extension String {
    func ifEmpty(_ fallback: String) -> String {
        isEmpty ? fallback : self
    }
}
