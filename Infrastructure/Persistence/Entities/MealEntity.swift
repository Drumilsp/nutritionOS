//
//  MealEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of a reusable meal template.
@Model
final class MealEntity {

    // MARK: - Properties

    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var mealItems: [MealItemEntity]
    var notes: String?
    var isFavorite: Bool
    var isArchived: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        name: String,
        mealItems: [MealItemEntity],
        notes: String?,
        isFavorite: Bool,
        isArchived: Bool,
        createdAt: Date,
        updatedAt: Date
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
