//
//  NutrientValueEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of a nutrient value.
@Model
final class NutrientValueEntity {

    // MARK: - Properties

    var id: UUID
    var nutrientTypeID: String
    var nutrientTypeName: String
    var value: Double
    var unitSymbol: String

    // MARK: - Initialization

    init(
        id: UUID,
        nutrientTypeID: String,
        nutrientTypeName: String,
        value: Double,
        unitSymbol: String
    ) {
        self.id = id
        self.nutrientTypeID = nutrientTypeID
        self.nutrientTypeName = nutrientTypeName
        self.value = value
        self.unitSymbol = unitSymbol
    }
}
