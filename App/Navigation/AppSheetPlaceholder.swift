import SwiftUI

/// Temporary modal content used to validate centralized sheet routing.
struct AppSheetPlaceholder: View {

    // MARK: - Properties

    let destination: AppSheetDestination
    let onRoute: (AppSheetDestination) -> Void
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                EmptyStateView(
                    title: title,
                    message: "This flow will be implemented in a future sprint.",
                    systemImage: icon
                )

                if destination == .quickLog {
                    VStack(spacing: AppSpacing.sm) {
                        PrimaryButton("Create Food", systemImage: AppIcons.createFood) {
                            onRoute(.createFood)
                        }
                        SecondaryButton("Create Meal", systemImage: AppIcons.createMeal) {
                            onRoute(.createMeal)
                        }
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.background)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: onDismiss)
                }
            }
        }
    }

    // MARK: - Private Properties

    private var title: String {
        switch destination {
        case .quickLog: "Quick Log"
        case .createFood: "Create Food"
        case .createMeal: "Create Meal"
        }
    }

    private var icon: String {
        switch destination {
        case .quickLog: AppIcons.quickLog
        case .createFood: AppIcons.createFood
        case .createMeal: AppIcons.createMeal
        }
    }
}

#Preview("Quick Log") {
    AppSheetPlaceholder(destination: .quickLog, onRoute: { _ in }, onDismiss: {})
}

#Preview("Create Food") {
    AppSheetPlaceholder(destination: .createFood, onRoute: { _ in }, onDismiss: {})
}

#Preview("Create Meal") {
    AppSheetPlaceholder(destination: .createMeal, onRoute: { _ in }, onDismiss: {})
}
