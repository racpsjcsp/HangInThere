//
//  HapticFeedbackPlayer.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import UIKit

@MainActor
protocol HapticPlaying: AnyObject {
    var isHapticsEnabled: Bool { get set }
    func toggle()
}

@MainActor
final class HapticFeedbackPlayer: HapticPlaying {
    static let shared = HapticFeedbackPlayer()
    private static let hapticsEnabledKey = "haptics_enabled"

    private let impactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let userDefaults: UserDefaults

    var isHapticsEnabled: Bool {
        get { userDefaults.object(forKey: Self.hapticsEnabledKey) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: Self.hapticsEnabledKey) }
    }

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func toggle() {
        guard isHapticsEnabled else { return }
        impactGenerator.prepare()
        notificationGenerator.prepare()
        impactGenerator.impactOccurred(intensity: 1)
        notificationGenerator.notificationOccurred(.success)
    }
}

@MainActor
final class SilentHapticPlayer: HapticPlaying {
    static let shared = SilentHapticPlayer()

    var isHapticsEnabled = false

    private init() {}

    func toggle() {}
}
