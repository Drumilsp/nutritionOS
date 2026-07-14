//
//  MealItem.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents one food ingredient inside a reusable meal.
final class MealItem: Identifiable {

    // MARK: - Properties

    let id: UUID
    let foodReference: Food
    var quantity: Double
    var servingUnit: ServingUnit

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        foodReference: Food,
        quantity: Double,
        servingUnit: ServingUnit? = nil
    ) {
        self.id = id
        self.foodReference = foodReference
        self.quantity = quantity
        self.servingUnit = servingUnit ?? foodReference.referenceUnit
    }
}
