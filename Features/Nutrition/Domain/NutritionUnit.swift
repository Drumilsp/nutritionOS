//
//  NutritionUnit.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents the measurement unit for a nutrient value.
struct NutritionUnit: Hashable {

    // MARK: - Properties

    let symbol: String

    // MARK: - Initialization

    init(symbol: String) {
        self.symbol = symbol
    }

    // MARK: - Common Units

    static let kilocalories = NutritionUnit(symbol: "kcal")
    static let grams = NutritionUnit(symbol: "g")
}
