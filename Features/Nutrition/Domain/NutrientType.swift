//
//  NutrientType.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Identifies a nutrient tracked by a nutrition profile.
struct NutrientType: Hashable, Identifiable {

    // MARK: - Properties

    let id: String
    let name: String

    // MARK: - Initialization

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    // MARK: - Founder Edition Nutrients

    static let calories = NutrientType(id: "calories", name: "Calories")
    static let protein = NutrientType(id: "protein", name: "Protein")
    static let carbohydrates = NutrientType(id: "carbohydrates", name: "Carbohydrates")
    static let fat = NutrientType(id: "fat", name: "Fat")
    static let fibre = NutrientType(id: "fibre", name: "Fibre")
}
