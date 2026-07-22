import SwiftUI

struct FloatingActionButton: View {
    let accessibilityLabel: String; let systemImage: String; let action: () -> Void
    init(accessibilityLabel: String, systemImage: String = AppIcons.add, action: @escaping () -> Void) { self.accessibilityLabel = accessibilityLabel; self.systemImage = systemImage; self.action = action }
    var body: some View { Button(action: action) { Image(systemName: systemImage).font(.headline.weight(.bold)).frame(width: 56, height: 56).foregroundStyle(AppColors.onAccent).background(AppColors.accent, in: Circle()).shadow(color: AppShadow.color, radius: AppShadow.radius, y: AppShadow.y) }.accessibilityLabel(accessibilityLabel).accessibilityHint("Double tap to activate") }
}
#Preview { FloatingActionButton(accessibilityLabel: "Add item") {}.padding() }
