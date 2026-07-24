import SwiftUI

struct TimelineEntryRow: View {
    let entry: TimelineEntry

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Image(systemName: icon).foregroundStyle(AppColors.accent).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title).font(AppTypography.headline)
                Text(detail).font(AppTypography.callout).foregroundStyle(AppColors.secondaryText)
                Text(entry.timestamp, format: .dateTime.hour().minute()).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
            }
            Spacer(minLength: AppSpacing.sm)
            Text(value).font(AppTypography.callout.weight(.semibold)).multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
    }

    private var title: String { switch entry { case .food(let food): food.foodName; case .meal(let meal): meal.mealName; case .water: "Water" } }
    private var detail: String { switch entry { case .food(let food): "\(food.loggedQuantity.formatted()) \(food.referenceUnit.name)"; case .meal(let meal): "\(meal.loggedFoods.count) foods"; case .water: "Hydration" } }
    private var value: String { switch entry { case .food(let food): NutritionFormatter.energy(food.nutritionProfileSnapshot.value(for: .calories)); case .meal(let meal): NutritionFormatter.energy(meal.loggedFoods.reduce(0) { $0 + $1.nutritionProfileSnapshot.value(for: .calories) }); case .water(let water): WaterFormatter.string(water.amount) } }
    private var icon: String { switch entry { case .food: AppIcons.createFood; case .meal: AppIcons.createMeal; case .water: AppIcons.water } }
}
