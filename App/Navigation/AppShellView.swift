import SwiftUI

/// Hosts the application-wide navigation stack, tab selection, and modal routing.
struct AppShellView<TodayContent: View, ProgressContent: View, QuickLogContent: View, SettingsContent: View, FoodLibraryContent: View, MealLibraryContent: View>: View {

    // MARK: - State

    @State private var selectedTab: AppTab = .today
    @State private var navigationPath = NavigationPath()
    @State private var sheetDestination: AppSheetDestination?

    private let todayContent: TodayContent
    private let progressContent: ProgressContent
    private let quickLogContent: QuickLogContent
    private let settingsContent: SettingsContent
    private let foodLibraryContent: FoodLibraryContent
    private let mealLibraryContent: MealLibraryContent

    // MARK: - Initialization

    init(
        @ViewBuilder today: () -> TodayContent,
        @ViewBuilder progress: () -> ProgressContent,
        @ViewBuilder quickLog: () -> QuickLogContent,
        @ViewBuilder settings: () -> SettingsContent,
        @ViewBuilder foodLibrary: () -> FoodLibraryContent,
        @ViewBuilder mealLibrary: () -> MealLibraryContent
    ) {
        self.todayContent = today()
        self.progressContent = progress()
        self.quickLogContent = quickLog()
        self.settingsContent = settings()
        self.foodLibraryContent = foodLibrary()
        self.mealLibraryContent = mealLibrary()
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                todayContent
                    .tag(AppTab.today)
                    .tabItem { Label(AppTab.today.title, systemImage: AppTab.today.icon) }

                progressContent
                    .tag(AppTab.progress)
                    .tabItem { Label(AppTab.progress.title, systemImage: AppTab.progress.icon) }

                settingsContent
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
                switch destination {
                case .food: foodLibraryContent
                case .meal: mealLibraryContent
                default: AppDestinationPlaceholder(destination: destination)
                }
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
        progress: { AppPlaceholderScreen(tab: .progress) },
        quickLog: { AppSheetPlaceholder(destination: .quickLog, onRoute: { _ in }, onDismiss: {}) },
        settings: { ManageFoodsSettingsView() },
        foodLibrary: { EmptyView() },
        mealLibrary: { EmptyView() }
    )
}
