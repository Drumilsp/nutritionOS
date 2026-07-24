import SwiftUI

struct EnergyDistributionView: View {
    let totals: DailyTotals?

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            distributionValue(title: "Protein", value: percentage(proteinCalories), tint: AppColors.success)
            distributionValue(title: "Carbohydrates", value: percentage(carbohydrateCalories), tint: AppColors.accent)
            distributionValue(title: "Fat", value: percentage(fatCalories), tint: AppColors.warning)
        }
        .accessibilityElement(children: .combine)
    }

    private var proteinCalories: Double { (totals?.protein ?? 0) * 4 }
    private var carbohydrateCalories: Double { (totals?.carbohydrates ?? 0) * 4 }
    private var fatCalories: Double { (totals?.fat ?? 0) * 9 }
    private var totalCalories: Double { proteinCalories + carbohydrateCalories + fatCalories }

    private func percentage(_ calories: Double) -> String {
        guard totalCalories > 0 else { return "0%" }
        return "\((calories / totalCalories * 100).formatted(.number.precision(.fractionLength(0))))%"
    }

    private func distributionValue(title: String, value: String, tint: Color) -> some View {
        VStack(spacing: AppSpacing.xs) {
            Text(value).font(AppTypography.title).foregroundStyle(tint)
            Text(title).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 44)
    }
}
