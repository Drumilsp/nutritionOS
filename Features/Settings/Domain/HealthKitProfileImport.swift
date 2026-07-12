//
//  HealthKitProfileImport.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents optional HealthKit profile values prepared outside the use case layer.
struct HealthKitProfileImport {
    let height: Double?
    let currentWeight: Double?
    let activeCalories: Double?

    init(
        height: Double? = nil,
        currentWeight: Double? = nil,
        activeCalories: Double? = nil
    ) {
        self.height = height
        self.currentWeight = currentWeight
        self.activeCalories = activeCalories
    }
}
