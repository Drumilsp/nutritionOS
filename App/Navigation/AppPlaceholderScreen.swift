import SwiftUI

/// Temporary tab content used to validate navigation before feature implementation.
struct AppPlaceholderScreen: View {

    // MARK: - Properties

    let tab: AppTab

    // MARK: - Body

    var body: some View {
        ScrollView {
            AppCard {
                EmptyStateView(
                    title: tab.title,
                    message: tab.placeholderMessage,
                    systemImage: tab.icon
                )
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.background)
        .navigationTitle(tab.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview("Today") {
    NavigationStack {
        AppPlaceholderScreen(tab: .today)
    }
}

#Preview("Progress") {
    NavigationStack {
        AppPlaceholderScreen(tab: .progress)
    }
}

#Preview("Settings") {
    NavigationStack {
        AppPlaceholderScreen(tab: .settings)
    }
}
