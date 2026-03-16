//
//  SoundEffectPlayer.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import AVFoundation
import Foundation

enum SoundEffect {
    case claimReward
    case correctGuess
    case wrongGuess
    case winRound
    case loseRound
    case revealPower
    case freeGuessPower
    case levelUp
    case soundToggle

    fileprivate var fileName: String {
        switch self {
        case .claimReward: "claimReward"
        case .correctGuess: "correctGuess"
        case .wrongGuess: "wrongGuess"
        case .winRound: "winRound"
        case .loseRound: "loseRound"
        case .revealPower: "revealSound"
        case .freeGuessPower: "freeGuessPower"
        case .levelUp: "levelUp"
        case .soundToggle: "soundToggle"
        }
    }
}

@MainActor
protocol SoundPlaying: AnyObject {
    var isSoundEnabled: Bool { get set }
    func play(_ effect: SoundEffect)
}

@MainActor
final class SilentSoundPlayer: SoundPlaying {
    static let shared = SilentSoundPlayer()

    var isSoundEnabled = false

    private init() {}

    func play(_ effect: SoundEffect) {}
}

@MainActor
final class SoundEffectPlayer: SoundPlaying {
    static let shared = SoundEffectPlayer()
    private static let soundEnabledKey = "sound_effects_enabled"

    private let userDefaults: UserDefaults
    private let bundle: Bundle
    private var players: [SoundEffect: AVAudioPlayer] = [:]
    private var isSessionConfigured = false

    var isSoundEnabled: Bool {
        get { userDefaults.object(forKey: Self.soundEnabledKey) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: Self.soundEnabledKey) }
    }

    private init(userDefaults: UserDefaults = .standard, bundle: Bundle = .main) {
        self.userDefaults = userDefaults
        self.bundle = bundle
    }

    func play(_ effect: SoundEffect) {
        guard isSoundEnabled else { return }

        do {
            try configureSessionIfNeeded()
            let player = try player(for: effect)
            player.currentTime = 0
            player.play()
        } catch {
            assertionFailure("Failed to play sound effect \(effect.fileName): \(error)")
        }
    }

    private func configureSessionIfNeeded() throws {
        guard !isSessionConfigured else { return }

        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true, options: [])
        #endif

        isSessionConfigured = true
    }

    private func player(for effect: SoundEffect) throws -> AVAudioPlayer {
        if let player = players[effect] {
            return player
        }

        let url = bundle.url(forResource: effect.fileName, withExtension: "wav", subdirectory: "Sounds")
            ?? bundle.url(forResource: effect.fileName, withExtension: "wav")

        guard let url else {
            throw NSError(
                domain: "SoundEffectPlayer",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Missing sound file \(effect.fileName).wav in app bundle"]
            )
        }

        let player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        players[effect] = player
        return player
    }
}
