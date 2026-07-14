//
//  DailyLog.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents one calendar day's nutrition log and immutable goal snapshots.
final class DailyLog: Identifiable {

    // MARK: - Properties

    let id: UUID
    let date: Date
    var loggedFoods: [LoggedFood]
    var loggedMeals: [LoggedMeal]
    var waterIntake: Double
    var waterEntries: [WaterEntry]
    let calorieGoalSnapshot: Double
    let proteinGoalSnapshot: Double
    let carbohydrateGoalSnapshot: Double
    let fatGoalSnapshot: Double
    let fibreGoalSnapshot: Double
    let waterGoalSnapshot: Double
    let maintenanceCaloriesSnapshot: Double
    var activeCalories: Double?
    var restingCalories: Double?
    var notes: String?
    var isCompleted: Bool
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        date: Date,
        loggedFoods: [LoggedFood] = [],
        loggedMeals: [LoggedMeal] = [],
        waterIntake: Double = 0,
        waterEntries: [WaterEntry] = [],
        calorieGoalSnapshot: Double,
        proteinGoalSnapshot: Double,
        carbohydrateGoalSnapshot: Double = 0,
        fatGoalSnapshot: Double,
        fibreGoalSnapshot: Double,
        waterGoalSnapshot: Double = 0,
        maintenanceCaloriesSnapshot: Double,
        activeCalories: Double? = nil,
        restingCalories: Double? = nil,
        notes: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.loggedFoods = loggedFoods
        self.loggedMeals = loggedMeals
        self.waterIntake = waterIntake
        self.waterEntries = waterEntries
        self.calorieGoalSnapshot = calorieGoalSnapshot
        self.proteinGoalSnapshot = proteinGoalSnapshot
        self.carbohydrateGoalSnapshot = carbohydrateGoalSnapshot
        self.fatGoalSnapshot = fatGoalSnapshot
        self.fibreGoalSnapshot = fibreGoalSnapshot
        self.waterGoalSnapshot = waterGoalSnapshot
        self.maintenanceCaloriesSnapshot = maintenanceCaloriesSnapshot
        self.activeCalories = activeCalories
        self.restingCalories = restingCalories
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var totalWater: Double { waterEntries.isEmpty ? waterIntake : waterEntries.reduce(0) { $0 + $1.amount } }
}
