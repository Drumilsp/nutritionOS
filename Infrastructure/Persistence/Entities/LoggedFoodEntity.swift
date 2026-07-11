//
//  LoggedFoodEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of an immutable logged food snapshot.
@Model
final class LoggedFoodEntity {

    // MARK: - Properties

    var id: UUID
    var foodName: String
    var category: String?
    var referenceQuantity: Double
    var referenceUnitName: String
    var loggedQuantity: Double
    @Relationship(deleteRule: .cascade) var nutrientValues: [NutrientValueEntity]
    var mealSlotRawValue: String
    var createdAt: Date
    var notes: String?

    // MARK: - Initialization

    init(
        id: UUID,
        foodName: String,
        category: String?,
        referenceQuantity: Double,
        referenceUnitName: String,
        loggedQuantity: Double,
        nutrientValues: [NutrientValueEntity],
        mealSlotRawValue: String,
        createdAt: Date,
        notes: String?
    ) {
        self.id = id
        self.foodName = foodName
        self.category = category
        self.referenceQuantity = referenceQuantity
        self.referenceUnitName = referenceUnitName
        self.loggedQuantity = loggedQuantity
        self.nutrientValues = nutrientValues
        self.mealSlotRawValue = mealSlotRawValue
        self.createdAt = createdAt
        self.notes = notes
    }
}
