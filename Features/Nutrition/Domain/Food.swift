//
//  Food.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents a reusable food template.
final class Food: Identifiable {

    // MARK: - Properties

    let id: UUID
    var name: String
    var category: String?
    var referenceQuantity: Double
    var referenceUnit: ServingUnit
    var nutritionProfile: NutritionProfile
    var notes: String?
    var isFavorite: Bool
    var isArchived: Bool
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        category: String? = nil,
        referenceQuantity: Double,
        referenceUnit: ServingUnit,
        nutritionProfile: NutritionProfile,
        notes: String? = nil,
        isFavorite: Bool = false,
        isArchived: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.referenceQuantity = referenceQuantity
        self.referenceUnit = referenceUnit
        self.nutritionProfile = nutritionProfile
        self.notes = notes
        self.isFavorite = isFavorite
        self.isArchived = isArchived
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
