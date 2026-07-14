//
//  LoggedFood.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents an immutable snapshot of food consumed by the user.
final class LoggedFood: Identifiable {

    // MARK: - Properties

    let id: UUID
    let foodID: UUID?
    let foodName: String
    let category: String?
    let referenceQuantity: Double
    let referenceUnit: ServingUnit
    let loggedQuantity: Double
    let nutritionProfileSnapshot: NutritionProfile
    let mealSlot: MealSlot?
    let createdAt: Date
    let source: LoggedEntrySource
    let notes: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        foodID: UUID? = nil,
        foodName: String,
        category: String? = nil,
        referenceQuantity: Double,
        referenceUnit: ServingUnit,
        loggedQuantity: Double,
        nutritionProfileSnapshot: NutritionProfile,
        mealSlot: MealSlot? = nil,
        createdAt: Date = Date(),
        source: LoggedEntrySource = .manualFood,
        notes: String? = nil
    ) {
        self.id = id
        self.foodID = foodID
        self.foodName = foodName
        self.category = category
        self.referenceQuantity = referenceQuantity
        self.referenceUnit = referenceUnit
        self.loggedQuantity = loggedQuantity
        self.nutritionProfileSnapshot = nutritionProfileSnapshot
        self.mealSlot = mealSlot
        self.createdAt = createdAt
        self.source = source
        self.notes = notes
    }
}
