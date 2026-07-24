import SwiftUI

struct DailySummaryCardView: View {
    let data: DashboardData?
    let isLoading: Bool

    var body: some View {
        AppCard {
            if let data {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text(data.currentDate, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(AppTypography.callout)
                        .foregroundStyle(AppColors.secondaryText)
                    Text("Daily Summary").font(AppTypography.title)
                    MetricRow(title: "Calories", value: "\(NutritionFormatter.energy(data.energySummary.foodCalories)) / \(NutritionFormatter.energy(data.energySummary.targetCalories))", systemImage: AppIcons.energy)
                    MetricRow(title: "Remaining", value: NutritionFormatter.energy(data.energySummary.remainingCalories), systemImage: AppIcons.remaining)
                    MacroProgressBar(title: "Protein", current: data.macroSummary.protein.current, goal: data.macroSummary.protein.goal, tint: AppColors.success)
                    MetricRow(title: "Energy Balance", value: NutritionFormatter.energy(data.energySummary.foodCalories - data.energySummary.targetCalories), systemImage: AppIcons.balance)
                }
            } else if isLoading {
                VStack(alignment: .leading, spacing: AppSpacing.sm) { LoadingSkeleton(height: 24); LoadingSkeleton(); LoadingSkeleton() }
            } else {
                EmptyStateView(title: "Daily Summary", message: "Your summary will appear when daily data is available.", systemImage: AppIcons.info)
            }
        }
    }
}
