import SwiftUI

struct FoodRowView: View {
    let food: Food

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: AppIcons.createFood)
                .foregroundStyle(AppColors.secondaryText)
                .frame(width: 30, height: 30)
                .background(AppColors.background, in: RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(food.name)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.primaryText)
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }

            Spacer(minLength: AppSpacing.sm)

            VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                Text(NutritionFormatter.energy(food.nutritionProfile.value(for: .calories)))
                    .font(AppTypography.headline.monospacedDigit())
                if food.isFavorite {
                    Image(systemName: "star.fill")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.warning)
                        .accessibilityLabel("Favorite")
                }
            }
            .foregroundStyle(AppColors.secondaryText)
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .combine)
    }

    private var subtitle: String {
        let category = food.category ?? "Uncategorized"
        return "\(category) · \(food.referenceQuantity.formatted()) \(food.referenceUnit.name)"
    }
}

#Preview {
    FoodRowView(
        food: Food(
            name: "Greek Yogurt",
            category: FoodCategory.dairy.rawValue,
            referenceQuantity: 170,
            referenceUnit: .grams,
            nutritionProfile: NutritionProfile(nutrientValues: [
                NutrientValue(nutrientType: .calories, value: 130, unit: .kilocalories)
            ]),
            isFavorite: true
        )
    )
    .padding()
}
