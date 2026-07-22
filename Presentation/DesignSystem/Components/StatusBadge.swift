import SwiftUI

enum StatusBadgeTone { case neutral, success, warning, destructive
    var color: Color { switch self { case .neutral: AppColors.accent; case .success: AppColors.success; case .warning: AppColors.warning; case .destructive: AppColors.destructive } }
}
struct StatusBadge: View {
    let title: String; let tone: StatusBadgeTone
    init(_ title: String, tone: StatusBadgeTone = .neutral) { self.title = title; self.tone = tone }
    var body: some View { Text(title).font(AppTypography.caption.weight(.semibold)).foregroundStyle(tone.color).padding(.horizontal, AppSpacing.xs).padding(.vertical, AppSpacing.xxs).background(tone.color.opacity(0.14), in: Capsule()).accessibilityLabel(title) }
}
#Preview { HStack { StatusBadge("On track", tone: .success); StatusBadge("Warning", tone: .warning) }.padding() }
