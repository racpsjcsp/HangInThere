//
//  HapticFeedbackPlayer.swift
//  HangInThere
//
//  Created by Codex on 13/03/26.
//

import UIKit

@MainActor
protocol HapticPlaying: AnyObject {
    func toggle()
}

@MainActor
final class HapticFeedbackPlayer: HapticPlaying {
    static let shared = HapticFeedbackPlayer()

    private let impactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationGenerator = UINotificationFeedbackGenerator()

    private init() {}

    func toggle() {
        impactGenerator.prepare()
        notificationGenerator.prepare()
        impactGenerator.impactOccurred(intensity: 1)
        notificationGenerator.notificationOccurred(.success)
    }
}

@MainActor
final class SilentHapticPlayer: HapticPlaying {
    static let shared = SilentHapticPlayer()

    private init() {}

    func toggle() {}
}
