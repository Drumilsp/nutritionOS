//
//  LoggedMealEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of an immutable logged meal snapshot.
@Model
final class LoggedMealEntity {

    // MARK: - Properties

    var id: UUID
    var mealID: UUID?
    var mealName: String
    @Relationship(deleteRule: .cascade) var loggedFoods: [LoggedFoodEntity]
    var mealSlotRawValue: String
    var servingMultiplier: Double
    var sourceRawValue: String
    var createdAt: Date
    var notes: String?

    // MARK: - Initialization

    init(
        id: UUID,
        mealID: UUID?,
        mealName: String,
        loggedFoods: [LoggedFoodEntity],
        mealSlotRawValue: String,
        servingMultiplier: Double,
        sourceRawValue: String,
        createdAt: Date,
        notes: String?
    ) {
        self.id = id
        self.mealID = mealID
        self.mealName = mealName
        self.loggedFoods = loggedFoods
        self.mealSlotRawValue = mealSlotRawValue
        self.servingMultiplier = servingMultiplier
        self.sourceRawValue = sourceRawValue
        self.createdAt = createdAt
        self.notes = notes
    }
}
