//
//  AppTheme.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

enum AppTheme {
    static let background = LinearGradient(
        colors: [Color(red: 0.08, green: 0.11, blue: 0.20), Color(red: 0.13, green: 0.23, blue: 0.28)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let panelBackground = Color.white.opacity(0.11)
    static let panelBorder = Color.white.opacity(0.14)
    static let primary = Color(red: 0.96, green: 0.60, blue: 0.19)
    static let secondary = Color(red: 0.39, green: 0.84, blue: 0.72)
    static let accent = Color(red: 0.94, green: 0.30, blue: 0.38)
    static let success = Color(red: 0.48, green: 0.88, blue: 0.51)
    static let warning = Color(red: 0.98, green: 0.79, blue: 0.28)
    static let powerBlue = Color(red: 0.16, green: 0.50, blue: 0.98)
    static let powerBlueDeep = Color(red: 0.08, green: 0.28, blue: 0.82)
    static let powerPurple = Color(red: 0.62, green: 0.29, blue: 0.96)
    static let powerPurpleDeep = Color(red: 0.33, green: 0.16, blue: 0.73)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textMuted = Color.white.opacity(0.55)

    enum Spacing {
        static let xxxSmall: CGFloat = 4
        static let xxSmall: CGFloat = 8
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }

    enum Radius {
        static let small: CGFloat = 14
        static let medium: CGFloat = 22
        static let large: CGFloat = 30
        static let capsule: CGFloat = 999
    }

    enum Typography {
        static func hero() -> Font { .system(size: 38, weight: .black, design: .rounded) }
        static func title() -> Font { .system(size: 28, weight: .bold, design: .rounded) }
        static func section() -> Font { .system(size: 20, weight: .bold, design: .rounded) }
        static func body() -> Font { .system(size: 16, weight: .medium, design: .rounded) }
        static func caption() -> Font { .system(size: 13, weight: .semibold, design: .rounded) }
        static func letter() -> Font { .system(size: 24, weight: .heavy, design: .rounded) }
    }

    enum Shadow {
        static let card = Color.black.opacity(0.18)
    }

    enum Motion {
        static let screenTransition = Animation.spring(response: 0.5, dampingFraction: 0.88)
        static let cardBounce = Animation.spring(response: 0.4, dampingFraction: 0.78)
        static let progressFill = Animation.easeInOut(duration: 0.45)
        static let feedbackPulse = Animation.spring(response: 0.28, dampingFraction: 0.58)
        static let summaryReveal = Animation.spring(response: 0.48, dampingFraction: 0.82)
        static let shake = Animation.linear(duration: 0.45)
        static let celebration = Animation.spring(response: 0.6, dampingFraction: 0.72)
    }
}
