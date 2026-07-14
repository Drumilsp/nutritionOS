//
//  MealItemEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of one food inside a meal template.
@Model
final class MealItemEntity {

    // MARK: - Properties

    var id: UUID
    var foodReference: FoodEntity?
    var quantity: Double
    var servingUnitName: String

    // MARK: - Initialization

    init(
        id: UUID,
        foodReference: FoodEntity?,
        quantity: Double,
        servingUnitName: String
    ) {
        self.id = id
        self.foodReference = foodReference
        self.quantity = quantity
        self.servingUnitName = servingUnitName
    }
}
