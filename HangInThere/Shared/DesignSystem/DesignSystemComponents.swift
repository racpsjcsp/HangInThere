//
//  DesignSystemComponents.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import SwiftUI

struct AppCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.Spacing.medium)
            .background(AppTheme.panelBackground, in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous)
                    .stroke(AppTheme.panelBorder, lineWidth: 1)
            }
            .shadow(color: AppTheme.Shadow.card, radius: 18, y: 12)
    }
}

struct AppButton: View {
    enum Style {
        case primary
        case secondary
        case ghost
        case powerReveal
        case powerFreeGuess
    }

    enum Layout {
        case horizontal
        case vertical
    }

    enum Size {
        case regular
        case compact
    }

    let title: String
    let systemImage: String?
    let style: Style
    let layout: Layout
    let size: Size
    let accessibilityIdentifier: String?
    let action: () -> Void

    init(
        title: String,
        systemImage: String?,
        style: Style,
        layout: Layout,
        size: Size = .regular,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.layout = layout
        self.size = size
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            content
            .font(font)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous)
                    .stroke(borderColor, lineWidth: style == .ghost ? 1 : 0)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityIdentifier ?? title)
    }

    private var content: some View {
        Group {
            switch layout {
            case .horizontal:
                HStack(spacing: AppTheme.Spacing.xSmall) {
                    icon
                    label
                }

            case .vertical:
                VStack(spacing: AppTheme.Spacing.xxxSmall) {
                    icon
                    label
                }
            }
        }
    }

    @ViewBuilder
    private var icon: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .font(iconFont)
                .frame(width: layout == .horizontal ? 14 : nil)
        }
    }

    private var label: some View {
        Text(title)
            .lineLimit(layout == .horizontal ? 1 : 2)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(layout == .horizontal ? 0.75 : 0.9)
    }

    private var horizontalPadding: CGFloat {
        size == .compact ? AppTheme.Spacing.xSmall : AppTheme.Spacing.small
    }

    private var verticalPadding: CGFloat {
        size == .compact ? AppTheme.Spacing.xSmall : AppTheme.Spacing.small
    }

    private var font: Font {
        size == .compact ? AppTheme.Typography.caption() : AppTheme.Typography.body()
    }

    private var iconFont: Font {
        size == .compact ? .system(size: 15, weight: .bold) : .system(size: 16, weight: .semibold)
    }

    private var background: AnyShapeStyle {
        switch style {
        case .primary:
            AnyShapeStyle(LinearGradient(colors: [AppTheme.primary, AppTheme.warning], startPoint: .leading, endPoint: .trailing))
        case .secondary:
            AnyShapeStyle(LinearGradient(colors: [AppTheme.secondary, AppTheme.success], startPoint: .leading, endPoint: .trailing))
        case .ghost:
            AnyShapeStyle(Color.white.opacity(0.08))
        case .powerReveal:
            AnyShapeStyle(LinearGradient(colors: [AppTheme.warning, AppTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing))
        case .powerFreeGuess:
            AnyShapeStyle(LinearGradient(colors: [AppTheme.secondary, AppTheme.primary.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary, .secondary, .powerReveal, .powerFreeGuess:
            return Color.black.opacity(0.8)
        case .ghost:
            return AppTheme.textPrimary
        }
    }

    private var borderColor: Color {
        switch style {
        case .ghost:
            return AppTheme.panelBorder
        default:
            return .clear
        }
    }
}

struct AppStatBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
            Text(title.uppercased())
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.textMuted)
            Text(value)
                .font(AppTheme.Typography.section())
                .foregroundStyle(AppTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.small)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous))
    }
}

struct AppProgressBar: View {
    let progress: Double
    let fill: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))

                Capsule()
                    .fill(fill)
                    .frame(width: proxy.size.width * max(0, min(progress, 1)))
            }
        }
        .frame(height: 10)
    }
}

struct AppPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.caption())
            .foregroundStyle(Color.black.opacity(0.78))
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(color, in: Capsule())
    }
}
