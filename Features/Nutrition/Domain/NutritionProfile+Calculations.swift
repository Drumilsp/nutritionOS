//
//  NutritionProfile+Calculations.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

extension NutritionProfile {

    // MARK: - Public Methods

    func value(for nutrientType: NutrientType) -> Double {
        nutrientValues
            .filter { $0.nutrientType == nutrientType }
            .reduce(0) { $0 + $1.value }
    }

    func scaled(by multiplier: Double) -> NutritionProfile {
        NutritionProfile(
            nutrientValues: nutrientValues.map { nutrientValue in
                NutrientValue(
                    id: nutrientValue.id,
                    nutrientType: nutrientValue.nutrientType,
                    value: nutrientValue.value * multiplier,
                    unit: nutrientValue.unit
                )
            }
        )
    }
}
