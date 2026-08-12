//
//  DashboardSummary.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents dashboard-ready nutrition totals for a daily log.
struct DashboardSummary {

    // MARK: - Properties

    let date: Date
    let caloriesConsumed: Double
    let proteinConsumed: Double
    let carbohydratesConsumed: Double
    let fatConsumed: Double
    let fibreConsumed: Double
    let waterIntake: Double
    let calorieGoal: Double
    let proteinGoal: Double
    let fatGoal: Double
    let fibreGoal: Double
    let maintenanceCalories: Double
    let activeCalories: Double?
    let restingCalories: Double?

    var remainingCalories: Double {
        calorieGoal - caloriesConsumed
    }
}
