import SwiftUI

struct EmptyStateView: View {
    let title: String; let message: String; let systemImage: String; let actionTitle: String?; let action: (() -> Void)?
    init(title: String, message: String, systemImage: String = AppIcons.empty, actionTitle: String? = nil, action: (() -> Void)? = nil) { self.title = title; self.message = message; self.systemImage = systemImage; self.actionTitle = actionTitle; self.action = action }
    var body: some View { VStack(spacing: AppSpacing.md) { Image(systemName: systemImage).font(.system(size: 40)).foregroundStyle(AppColors.secondaryText).accessibilityHidden(true); Text(title).font(AppTypography.title); Text(message).font(AppTypography.body).foregroundStyle(AppColors.secondaryText).multilineTextAlignment(.center); if let actionTitle, let action { PrimaryButton(actionTitle, action: action) } }.padding(AppSpacing.xl).frame(maxWidth: .infinity).accessibilityElement(children: .contain) }
}
#Preview { EmptyStateView(title: "No meals yet", message: "Create one when you are ready.", actionTitle: "Create meal") {}.padding() }
