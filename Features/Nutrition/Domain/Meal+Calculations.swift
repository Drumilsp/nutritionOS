//
//  Meal+Calculations.swift
//  Nutri
//

import Foundation

extension Meal {

    /// Calculates current nutrition from the referenced foods without storing a copy.
    func nutritionProfile() -> NutritionProfile {
        let values = mealItems.flatMap { mealItem in
            mealItem.foodReference.nutritionProfile.scaled(
                by: mealItem.quantity / mealItem.foodReference.referenceQuantity
            ).nutrientValues
        }
        let groupedValues = Dictionary(grouping: values, by: \.nutrientType)

        return NutritionProfile(
            nutrientValues: groupedValues.values.compactMap { nutrientValues in
                guard let firstValue = nutrientValues.first else { return nil }
                return NutrientValue(
                    nutrientType: firstValue.nutrientType,
                    value: nutrientValues.reduce(0) { $0 + $1.value },
                    unit: firstValue.unit
                )
            }
        )
    }
}
