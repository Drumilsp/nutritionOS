//
//  EnergySummary.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents today's prepared energy values for the Dashboard.
struct EnergySummary {

    // MARK: - Properties

    let targetCalories: Double
    let foodCalories: Double
    let maintenanceCalories: Double
    let remainingCalories: Double
    let restingCalories: Double
    let activeCalories: Double
    let caloriesBurned: Double
    let energyBalanceTarget: EnergyBalanceTarget
}
