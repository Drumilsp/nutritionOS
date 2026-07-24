import SwiftUI

struct TodayView: View {

    // MARK: - Properties

    @ObservedObject private var dashboardViewModel: DashboardViewModel
    @ObservedObject private var dailyLogViewModel: DailyLogViewModel
    @Binding private var toastMessage: String?

    // MARK: - Initialization

    init(
        dashboardViewModel: DashboardViewModel,
        dailyLogViewModel: DailyLogViewModel,
        toastMessage: Binding<String?>
    ) {
        self.dashboardViewModel = dashboardViewModel
        self.dailyLogViewModel = dailyLogViewModel
        self._toastMessage = toastMessage
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                DailySummaryCardView(
                    data: dashboardViewModel.dashboardData,
                    isLoading: dashboardViewModel.state == .loading
                )

                timelineSection
                totalsSection
                energyDistributionSection
                suggestedFoodsSection
                suggestedMealsSection
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.background)
        .navigationTitle(AppTab.today.title)
        .navigationBarTitleDisplayMode(.large)
        .task {
            async let dashboard: Void = dashboardViewModel.load()
            async let dailyLog: Void = dailyLogViewModel.refresh()
            _ = await (dashboard, dailyLog)
        }
        .refreshable {
            async let dashboard: Void = dashboardViewModel.refresh()
            async let dailyLog: Void = dailyLogViewModel.refresh()
            _ = await (dashboard, dailyLog)
        }
        .overlay(alignment: .bottom) {
            if let toastMessage {
                Text(toastMessage)
                    .font(AppTypography.callout.weight(.semibold))
                    .foregroundStyle(AppColors.onAccent)
                    .padding(AppSpacing.sm)
                    .background(AppColors.accent, in: Capsule())
                    .padding(AppSpacing.lg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .animation(AppAnimation.standard, value: toastMessage)
        .onChange(of: toastMessage) { _, newValue in
            guard newValue != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(2))
                toastMessage = nil
            }
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private var timelineSection: some View {
        TodaySection(title: "Timeline") {
            switch dailyLogViewModel.state {
            case .loading:
                VStack(spacing: AppSpacing.sm) { LoadingSkeleton(); LoadingSkeleton(); LoadingSkeleton() }
            case .error:
                EmptyStateView(title: "Timeline unavailable", message: "Pull to refresh and try again.", systemImage: AppIcons.warning)
            case .empty:
                EmptyStateView(title: "Nothing logged today", message: "Use Quick Log to add food, meals, or water.")
            case .loaded where dailyLogViewModel.timeline.isEmpty:
                EmptyStateView(title: "Nothing logged today", message: "Use Quick Log to add food, meals, or water.")
            case .loaded:
                ForEach(dailyLogViewModel.timeline) { entry in
                    TimelineEntryRow(entry: entry)
                }
            }
        }
    }

    private var totalsSection: some View {
        TodaySection(title: "Today's Totals") {
            let totals = dailyLogViewModel.totals
            MetricRow(title: "Calories", value: NutritionFormatter.energy(totals?.calories ?? 0), systemImage: AppIcons.energy)
            MetricRow(title: "Protein", value: NutritionFormatter.macro(totals?.protein ?? 0), systemImage: AppIcons.protein, tint: AppColors.success)
            MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(totals?.carbohydrates ?? 0), systemImage: AppIcons.carbohydrates)
            MetricRow(title: "Fat", value: NutritionFormatter.macro(totals?.fat ?? 0), systemImage: AppIcons.fat)
            MetricRow(title: "Water", value: WaterFormatter.string(totals?.water ?? 0), systemImage: AppIcons.water)
        }
    }

    private var energyDistributionSection: some View {
        TodaySection(title: "Energy Distribution") {
            EnergyDistributionView(totals: dailyLogViewModel.totals)
        }
    }

    @ViewBuilder
    private var suggestedFoodsSection: some View {
        TodaySection(title: "Suggested Foods") {
            if dailyLogViewModel.suggestedFoods.isEmpty {
                Text("Suggestions will appear as you add foods.").font(AppTypography.callout).foregroundStyle(AppColors.secondaryText)
            } else {
                ForEach(dailyLogViewModel.suggestedFoods.prefix(8)) { food in
                    MetricRow(title: food.name, value: NutritionFormatter.energy(food.nutritionProfile.value(for: .calories)), systemImage: AppIcons.createFood)
                }
            }
        }
    }

    @ViewBuilder
    private var suggestedMealsSection: some View {
        TodaySection(title: "Suggested Meals") {
            if dailyLogViewModel.suggestedMeals.isEmpty {
                Text("Suggestions will appear as you create meals.").font(AppTypography.callout).foregroundStyle(AppColors.secondaryText)
            } else {
                ForEach(dailyLogViewModel.suggestedMeals.prefix(5)) { meal in
                    MetricRow(title: meal.name, value: "\(meal.mealItems.count) foods", systemImage: AppIcons.createMeal)
                }
            }
        }
    }
}

#Preview {
    Text("Today preview requires existing presentation view models.")
}
