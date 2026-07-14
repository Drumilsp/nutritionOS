//
//  FoodEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of a reusable food template.
@Model
final class FoodEntity {

    // MARK: - Properties

    var id: UUID
    var name: String
    var category: String?
    var referenceQuantity: Double
    var referenceUnitName: String
    @Relationship(deleteRule: .cascade) var nutrientValues: [NutrientValueEntity]
    var notes: String?
    var isSystemFood: Bool
    var isFavorite: Bool
    var isArchived: Bool
    var lastUsedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        name: String,
        category: String?,
        referenceQuantity: Double,
        referenceUnitName: String,
        nutrientValues: [NutrientValueEntity],
        notes: String?,
        isSystemFood: Bool,
        isFavorite: Bool,
        isArchived: Bool,
        lastUsedAt: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.referenceQuantity = referenceQuantity
        self.referenceUnitName = referenceUnitName
        self.nutrientValues = nutrientValues
        self.notes = notes
        self.isSystemFood = isSystemFood
        self.isFavorite = isFavorite
        self.isArchived = isArchived
        self.lastUsedAt = lastUsedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
