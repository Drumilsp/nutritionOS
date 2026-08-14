//
//  GoalSettings.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents nutrition goal configuration without a fixed daily calorie goal.
final class GoalSettings: Identifiable {

    // MARK: - Properties

    let id: UUID
    var goalType: GoalType
    var energyBalanceTarget: EnergyBalanceTarget
    var energyBalanceLowerBound: Double?
    var energyBalanceUpperBound: Double?
    var goalCalculationMode: GoalCalculationMode
    var activityLevel: ActivityLevel
    var dailyProteinGoal: Double
    var dailyCarbohydrateGoal: Double
    var dailyFatGoal: Double
    var dailyWaterGoal: Double
    var goalCalculationVersion: Int
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        goalType: GoalType,
        energyBalanceTarget: EnergyBalanceTarget,
        energyBalanceLowerBound: Double? = nil,
        energyBalanceUpperBound: Double? = nil,
        goalCalculationMode: GoalCalculationMode,
        activityLevel: ActivityLevel,
        dailyProteinGoal: Double,
        dailyCarbohydrateGoal: Double,
        dailyFatGoal: Double,
        dailyWaterGoal: Double,
        goalCalculationVersion: Int,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.goalType = goalType
        self.energyBalanceTarget = energyBalanceTarget
        self.energyBalanceLowerBound = energyBalanceLowerBound
        self.energyBalanceUpperBound = energyBalanceUpperBound
        self.goalCalculationMode = goalCalculationMode
        self.activityLevel = activityLevel
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyCarbohydrateGoal = dailyCarbohydrateGoal
        self.dailyFatGoal = dailyFatGoal
        self.dailyWaterGoal = dailyWaterGoal
        self.goalCalculationVersion = goalCalculationVersion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
