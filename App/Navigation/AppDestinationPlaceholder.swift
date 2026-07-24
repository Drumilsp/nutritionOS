import SwiftUI

/// Temporary content for destinations reserved for future navigation and deep links.
struct AppDestinationPlaceholder: View {

    // MARK: - Properties

    let destination: AppNavigationDestination

    // MARK: - Body

    var body: some View {
        EmptyStateView(
            title: title,
            message: "This destination will be implemented in a future sprint.",
            systemImage: AppIcons.info
        )
        .background(AppColors.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Private Properties

    private var title: String {
        switch destination {
        case .dailyLog: "Daily Log"
        case .food: "Food"
        case .meal: "Meal"
        case .progress: "Progress"
        case .settings: "Settings"
        }
    }
}
