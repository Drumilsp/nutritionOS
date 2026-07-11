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
    let mealName: String
    let loggedFoods: [LoggedFood]
    let mealSlot: MealSlot
    let createdAt: Date
    let notes: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        mealName: String,
        loggedFoods: [LoggedFood],
        mealSlot: MealSlot,
        createdAt: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.mealName = mealName
        self.loggedFoods = loggedFoods
        self.mealSlot = mealSlot
        self.createdAt = createdAt
        self.notes = notes
    }
}
