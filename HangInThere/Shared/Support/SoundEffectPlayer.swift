//
//  SoundEffectPlayer.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import AVFoundation
import Foundation

enum SoundEffect {
    case correctGuess
    case wrongGuess
    case winRound
    case loseRound
    case powerUp
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

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
    private lazy var buffers: [SoundEffect: AVAudioPCMBuffer] = [
        .correctGuess: makeBuffer(tones: [(880, 0.07), (1_176, 0.09)]),
        .wrongGuess: makeBuffer(tones: [(320, 0.08), (220, 0.14)]),
        .winRound: makeBuffer(tones: [(784, 0.1), (988, 0.1), (1_176, 0.16)]),
        .loseRound: makeBuffer(tones: [(330, 0.1), (247, 0.14), (196, 0.18)]),
        .powerUp: makeBuffer(tones: [(660, 0.05), (880, 0.08)])
    ]
    private var isConfigured = false
    var isSoundEnabled: Bool {
        get { userDefaults.object(forKey: Self.soundEnabledKey) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: Self.soundEnabledKey) }
    }
    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func play(_ effect: SoundEffect) {
        guard isSoundEnabled else { return }

        do {
            try configureIfNeeded()
            try startEngineIfNeeded()

            guard let buffer = buffers[effect] else { return }

            playerNode.stop()
            playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)

            if !playerNode.isPlaying {
                playerNode.play()
            }
        } catch {
            assertionFailure("Failed to play sound effect: \(error)")
        }
    }

    private func configureIfNeeded() throws {
        guard !isConfigured else { return }

        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true, options: [])
        #endif

        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        isConfigured = true
    }

    private func startEngineIfNeeded() throws {
        guard !engine.isRunning else { return }
        try engine.start()
    }

    private func makeBuffer(tones: [(frequency: Double, duration: Double)]) -> AVAudioPCMBuffer {
        let totalFrames = tones.reduce(0) { partialResult, tone in
            partialResult + Int(tone.duration * format.sampleRate)
        }
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(totalFrames))!
        buffer.frameLength = buffer.frameCapacity

        guard let channel = buffer.floatChannelData?[0] else { return buffer }

        var cursor = 0
        let sampleRate = format.sampleRate

        for tone in tones {
            let frameCount = Int(tone.duration * sampleRate)
            for frame in 0..<frameCount {
                let progress = Double(frame) / Double(max(frameCount - 1, 1))
                let envelope = amplitudeEnvelope(progress: progress)
                let sample = sin(2 * Double.pi * tone.frequency * Double(frame) / sampleRate) * envelope
                channel[cursor] = Float(sample * 0.3)
                cursor += 1
            }
        }

        return buffer
    }

    private func amplitudeEnvelope(progress: Double) -> Double {
        switch progress {
        case 0..<0.12:
            progress / 0.12
        case 0.12..<0.78:
            1
        default:
            max(0, 1 - ((progress - 0.78) / 0.22))
        }
    }
}
