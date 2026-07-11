//
//  Meal.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents a reusable meal template.
final class Meal: Identifiable {

    // MARK: - Properties

    let id: UUID
    var name: String
    var mealItems: [MealItem]
    var notes: String?
    var isFavorite: Bool
    var isArchived: Bool
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        mealItems: [MealItem],
        notes: String? = nil,
        isFavorite: Bool = false,
        isArchived: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.mealItems = mealItems
        self.notes = notes
        self.isFavorite = isFavorite
        self.isArchived = isArchived
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
