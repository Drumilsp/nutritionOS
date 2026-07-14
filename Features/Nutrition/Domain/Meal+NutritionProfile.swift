import Foundation

extension Meal {
    var nutritionProfile: NutritionProfile {
        NutritionProfile(nutrientValues: NutrientType.founderEdition.map { nutrient in
            NutrientValue(nutrientType: nutrient, value: mealItems.reduce(0) { $0 + $1.foodReference.nutritionProfile.scaled(by: $1.quantity / $1.foodReference.referenceQuantity).value(for: nutrient) }, unit: nutrient == .calories ? .kilocalories : .grams)
        })
    }
}

private extension NutrientType {
    static let founderEdition: [NutrientType] = [.calories, .protein, .carbohydrates, .fat]
}
