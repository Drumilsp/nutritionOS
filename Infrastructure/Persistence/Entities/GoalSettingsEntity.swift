//
//  GoalSettingsEntity.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of nutrition goal settings.
@Model
final class GoalSettingsEntity {

    // MARK: - Properties

    var id: UUID
    var goalTypeRawValue: String
    var energyBalanceTargetRawValue: String
    var goalCalculationModeRawValue: String
    var activityLevelRawValue: String
    var dailyProteinGoal: Double
    var dailyCarbohydrateGoal: Double
    var dailyFatGoal: Double
    var dailyWaterGoal: Double
    var goalCalculationVersion: Int
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        goalTypeRawValue: String,
        energyBalanceTargetRawValue: String,
        goalCalculationModeRawValue: String,
        activityLevelRawValue: String,
        dailyProteinGoal: Double,
        dailyCarbohydrateGoal: Double,
        dailyFatGoal: Double,
        dailyWaterGoal: Double,
        goalCalculationVersion: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.goalTypeRawValue = goalTypeRawValue
        self.energyBalanceTargetRawValue = energyBalanceTargetRawValue
        self.goalCalculationModeRawValue = goalCalculationModeRawValue
        self.activityLevelRawValue = activityLevelRawValue
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyCarbohydrateGoal = dailyCarbohydrateGoal
        self.dailyFatGoal = dailyFatGoal
        self.dailyWaterGoal = dailyWaterGoal
        self.goalCalculationVersion = goalCalculationVersion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
