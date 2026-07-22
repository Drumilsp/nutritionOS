import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
            .shadow(color: AppShadow.color, radius: AppShadow.radius, y: AppShadow.y)
    }
}

struct SectionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
    }
}

struct KeyboardAware: ViewModifier {
    func body(content: Content) -> some View {
        content.scrollDismissesKeyboard(.interactively)
    }
}

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.12).ignoresSafeArea()
                        ProgressView().controlSize(.large).padding(AppSpacing.lg).sectionStyle()
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Loading")
                    .accessibilityAddTraits(.isModal)
                }
            }
            .animation(AppAnimation.standard, value: isLoading)
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
    func sectionStyle() -> some View { modifier(SectionStyle()) }
    func keyboardAware() -> some View { modifier(KeyboardAware()) }
    func loadingOverlay(isLoading: Bool) -> some View { modifier(LoadingOverlay(isLoading: isLoading)) }
}
