//
//  DailyLogEntity.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of one calendar day's nutrition log.
@Model
final class DailyLogEntity {

    // MARK: - Properties

    var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var loggedFoods: [LoggedFoodEntity]
    @Relationship(deleteRule: .cascade) var loggedMeals: [LoggedMealEntity]
    var waterIntake: Double
    var calorieGoalSnapshot: Double
    var proteinGoalSnapshot: Double
    var fatGoalSnapshot: Double
    var fibreGoalSnapshot: Double
    var maintenanceCaloriesSnapshot: Double
    var activeCalories: Double?
    var restingCalories: Double?
    var notes: String?
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        date: Date,
        loggedFoods: [LoggedFoodEntity],
        loggedMeals: [LoggedMealEntity],
        waterIntake: Double,
        calorieGoalSnapshot: Double,
        proteinGoalSnapshot: Double,
        fatGoalSnapshot: Double,
        fibreGoalSnapshot: Double,
        maintenanceCaloriesSnapshot: Double,
        activeCalories: Double?,
        restingCalories: Double?,
        notes: String?,
        isCompleted: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.date = date
        self.loggedFoods = loggedFoods
        self.loggedMeals = loggedMeals
        self.waterIntake = waterIntake
        self.calorieGoalSnapshot = calorieGoalSnapshot
        self.proteinGoalSnapshot = proteinGoalSnapshot
        self.fatGoalSnapshot = fatGoalSnapshot
        self.fibreGoalSnapshot = fibreGoalSnapshot
        self.maintenanceCaloriesSnapshot = maintenanceCaloriesSnapshot
        self.activeCalories = activeCalories
        self.restingCalories = restingCalories
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
