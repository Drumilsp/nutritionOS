import SwiftUI

/// Hosts the application-wide navigation stack, tab selection, and modal routing.
struct AppShellView<TodayContent: View, QuickLogContent: View>: View {

    // MARK: - State

    @State private var selectedTab: AppTab = .today
    @State private var navigationPath = NavigationPath()
    @State private var sheetDestination: AppSheetDestination?

    private let todayContent: TodayContent
    private let quickLogContent: QuickLogContent

    // MARK: - Initialization

    init(
        @ViewBuilder today: () -> TodayContent,
        @ViewBuilder quickLog: () -> QuickLogContent
    ) {
        self.todayContent = today()
        self.quickLogContent = quickLog()
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                todayContent
                    .tag(AppTab.today)
                    .tabItem { Label(AppTab.today.title, systemImage: AppTab.today.icon) }

                AppPlaceholderScreen(tab: .progress)
                    .tag(AppTab.progress)
                    .tabItem { Label(AppTab.progress.title, systemImage: AppTab.progress.icon) }

                AppPlaceholderScreen(tab: .settings)
                    .tag(AppTab.settings)
                    .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.icon) }
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
            if destination == .quickLog {
                quickLogContent
            } else {
                AppSheetPlaceholder(
                    destination: destination,
                    onRoute: { sheetDestination = $0 },
                    onDismiss: { sheetDestination = nil }
                )
            }
        }
    }
}

#Preview {
    AppShellView(
        today: { AppPlaceholderScreen(tab: .today) },
        quickLog: { AppSheetPlaceholder(destination: .quickLog, onRoute: { _ in }, onDismiss: {}) }
    )
}
