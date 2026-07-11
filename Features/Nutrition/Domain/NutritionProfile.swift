//
//  NutritionProfile.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Stores sparse nutrition information for a food or snapshot.
struct NutritionProfile {

    // MARK: - Properties

    var nutrientValues: [NutrientValue]

    // MARK: - Initialization

    init(nutrientValues: [NutrientValue] = []) {
        self.nutrientValues = nutrientValues
    }
}
