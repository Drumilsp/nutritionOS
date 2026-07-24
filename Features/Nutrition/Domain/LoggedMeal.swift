//
//  LoggedMeal.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents an immutable snapshot of a meal consumed by the user.
final class LoggedMeal: Identifiable {

    // MARK: - Properties

    let id: UUID
    let mealID: UUID?
    let mealName: String
    let loggedFoods: [LoggedFood]
    let mealSlot: MealSlot?
    let servingMultiplier: Double
    let createdAt: Date
    let source: LoggedEntrySource
    let notes: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        mealID: UUID? = nil,
        mealName: String,
        loggedFoods: [LoggedFood],
        mealSlot: MealSlot? = nil,
        servingMultiplier: Double = 1,
        createdAt: Date = Date(),
        source: LoggedEntrySource = .mealTemplate,
        notes: String? = nil
    ) {
        self.id = id
        self.mealID = mealID
        self.mealName = mealName
        self.loggedFoods = loggedFoods
        self.mealSlot = mealSlot
        self.servingMultiplier = servingMultiplier
        self.createdAt = createdAt
        self.source = source
        self.notes = notes
    }
}
