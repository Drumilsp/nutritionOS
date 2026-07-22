import SwiftUI

enum AppButtonStyle { case primary, secondary, destructive }

private struct AppButton: View {
    let title: String
    let systemImage: String?
    let style: AppButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if let systemImage {
                    Label(title, systemImage: systemImage)
                } else {
                    Text(title)
                }
            }
            .font(AppTypography.button)
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.plain)
        .foregroundStyle(foreground)
        .background(background, in: RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous).stroke(border, lineWidth: 1) }
        .accessibilityHint("Activates \(title)")
    }

    private var foreground: Color { style == .secondary ? AppColors.accent : AppColors.onAccent }
    private var background: Color { style == .primary ? AppColors.accent : style == .destructive ? AppColors.destructive : .clear }
    private var border: Color { style == .secondary ? AppColors.accent : .clear }
}

struct PrimaryButton: View {
    let title: String; let systemImage: String?; let action: () -> Void
    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) { self.title = title; self.systemImage = systemImage; self.action = action }
    var body: some View { AppButton(title: title, systemImage: systemImage, style: .primary, action: action) }
}
struct SecondaryButton: View {
    let title: String; let systemImage: String?; let action: () -> Void
    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) { self.title = title; self.systemImage = systemImage; self.action = action }
    var body: some View { AppButton(title: title, systemImage: systemImage, style: .secondary, action: action) }
}
struct DestructiveButton: View {
    let title: String; let systemImage: String?; let action: () -> Void
    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) { self.title = title; self.systemImage = systemImage; self.action = action }
    var body: some View { AppButton(title: title, systemImage: systemImage, style: .destructive, action: action) }
}

#Preview("Primary Button") { PrimaryButton("Save") {}.padding() }
#Preview("Secondary Button") { SecondaryButton("Cancel") {}.padding() }
#Preview("Destructive Button") { DestructiveButton("Delete") {}.padding() }
