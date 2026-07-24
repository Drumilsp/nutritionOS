import SwiftUI

/// Hosts the application-wide navigation stack, tab selection, and modal routing.
struct AppShellView: View {

    // MARK: - State

    @State private var selectedTab: AppTab = .today
    @State private var navigationPath = NavigationPath()
    @State private var sheetDestination: AppSheetDestination?

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                ForEach([AppTab.today, .progress, .settings], id: \.self) { tab in
                    AppPlaceholderScreen(tab: tab)
                        .tag(tab)
                        .tabItem {
                            Label(tab.title, systemImage: tab.icon)
                        }
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if selectedTab == .today {
                    FloatingActionButton(accessibilityLabel: "Quick Log") {
                        sheetDestination = .quickLog
                    }
                    .padding(.trailing, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xs)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(AppAnimation.standard, value: selectedTab)
            .navigationDestination(for: AppNavigationDestination.self) { destination in
                AppDestinationPlaceholder(destination: destination)
            }
        }
        .sheet(item: $sheetDestination) { destination in
            AppSheetPlaceholder(
                destination: destination,
                onRoute: { sheetDestination = $0 },
                onDismiss: { sheetDestination = nil }
            )
        }
    }
}

#Preview {
    AppShellView()
}
