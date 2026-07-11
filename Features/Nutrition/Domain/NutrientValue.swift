//
//  NutrientValue.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents one stored nutrient value.
struct NutrientValue: Identifiable {

    // MARK: - Properties

    let id: UUID
    var nutrientType: NutrientType
    var value: Double
    var unit: NutritionUnit

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        nutrientType: NutrientType,
        value: Double,
        unit: NutritionUnit
    ) {
        self.id = id
        self.nutrientType = nutrientType
        self.value = value
        self.unit = unit
    }
}
