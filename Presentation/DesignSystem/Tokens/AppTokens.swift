import SwiftUI

enum AppColors {
    static let accent = Color.accentColor
    static let onAccent = Color.white
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let success = Color.green
    static let warning = Color.orange
    static let destructive = Color.red
    static let outline = Color(uiColor: .separator)
    static let skeleton = Color(uiColor: .tertiarySystemFill)
}

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppTypography {
    static let title = Font.title2.weight(.bold)
    static let headline = Font.headline
    static let body = Font.body
    static let callout = Font.callout
    static let caption = Font.caption
    static let button = Font.headline.weight(.semibold)
}

enum AppRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let pill: CGFloat = 999
}

enum AppShadow {
    static let color = Color.black.opacity(0.08)
    static let radius: CGFloat = 8
    static let y: CGFloat = 3
}

enum AppAnimation {
    static let standard = Animation.easeInOut(duration: 0.2)
    static let emphasis = Animation.spring(response: 0.35, dampingFraction: 0.8)
}

enum AppIcons {
    static let add = "plus"
    static let chevronForward = "chevron.forward"
    static let checkmark = "checkmark"
    static let warning = "exclamationmark.triangle.fill"
    static let error = "xmark.octagon.fill"
    static let info = "info.circle"
    static let protein = "leaf.fill"
    static let empty = "tray"
    static let close = "xmark"
}
