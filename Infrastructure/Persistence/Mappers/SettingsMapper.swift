//
//  SettingsMapper.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Maps Settings domain models to and from SwiftData entities.
enum SettingsMapper {

    // MARK: - UserProfile

    static func toDomain(_ entity: UserProfileEntity) -> UserProfile {
        UserProfile(
            id: entity.id,
            name: entity.name,
            dateOfBirth: entity.dateOfBirth,
            biologicalSex: BiologicalSex(rawValue: entity.biologicalSexRawValue) ?? .unspecified,
            height: entity.height,
            currentWeight: entity.currentWeight,
            targetWeight: entity.targetWeight,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toEntity(_ userProfile: UserProfile) -> UserProfileEntity {
        UserProfileEntity(
            id: userProfile.id,
            name: userProfile.name,
            dateOfBirth: userProfile.dateOfBirth,
            biologicalSexRawValue: userProfile.biologicalSex.rawValue,
            height: userProfile.height,
            currentWeight: userProfile.currentWeight,
            targetWeight: userProfile.targetWeight,
            createdAt: userProfile.createdAt,
            updatedAt: userProfile.updatedAt
        )
    }

    static func apply(_ userProfile: UserProfile, to entity: UserProfileEntity) {
        entity.name = userProfile.name
        entity.dateOfBirth = userProfile.dateOfBirth
        entity.biologicalSexRawValue = userProfile.biologicalSex.rawValue
        entity.height = userProfile.height
        entity.currentWeight = userProfile.currentWeight
        entity.targetWeight = userProfile.targetWeight
        entity.updatedAt = userProfile.updatedAt
    }

    // MARK: - GoalSettings

    static func toDomain(_ entity: GoalSettingsEntity) -> GoalSettings {
        GoalSettings(
            id: entity.id,
            goalType: GoalType(rawValue: entity.goalTypeRawValue) ?? .maintainWeight,
            energyBalanceTarget: EnergyBalanceTarget(rawValue: entity.energyBalanceTargetRawValue) ?? .maintain,
            goalCalculationMode: GoalCalculationMode(rawValue: entity.goalCalculationModeRawValue) ?? .automatic,
            activityLevel: ActivityLevel(rawValue: entity.activityLevelRawValue) ?? .lightlyActive,
            dailyProteinGoal: entity.dailyProteinGoal,
            dailyCarbohydrateGoal: entity.dailyCarbohydrateGoal,
            dailyFatGoal: entity.dailyFatGoal,
            dailyWaterGoal: entity.dailyWaterGoal,
            goalCalculationVersion: entity.goalCalculationVersion,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toEntity(_ goalSettings: GoalSettings) -> GoalSettingsEntity {
        GoalSettingsEntity(
            id: goalSettings.id,
            goalTypeRawValue: goalSettings.goalType.rawValue,
            energyBalanceTargetRawValue: goalSettings.energyBalanceTarget.rawValue,
            goalCalculationModeRawValue: goalSettings.goalCalculationMode.rawValue,
            activityLevelRawValue: goalSettings.activityLevel.rawValue,
            dailyProteinGoal: goalSettings.dailyProteinGoal,
            dailyCarbohydrateGoal: goalSettings.dailyCarbohydrateGoal,
            dailyFatGoal: goalSettings.dailyFatGoal,
            dailyWaterGoal: goalSettings.dailyWaterGoal,
            goalCalculationVersion: goalSettings.goalCalculationVersion,
            createdAt: goalSettings.createdAt,
            updatedAt: goalSettings.updatedAt
        )
    }

    static func apply(_ goalSettings: GoalSettings, to entity: GoalSettingsEntity) {
        entity.goalTypeRawValue = goalSettings.goalType.rawValue
        entity.energyBalanceTargetRawValue = goalSettings.energyBalanceTarget.rawValue
        entity.goalCalculationModeRawValue = goalSettings.goalCalculationMode.rawValue
        entity.activityLevelRawValue = goalSettings.activityLevel.rawValue
        entity.dailyProteinGoal = goalSettings.dailyProteinGoal
        entity.dailyCarbohydrateGoal = goalSettings.dailyCarbohydrateGoal
        entity.dailyFatGoal = goalSettings.dailyFatGoal
        entity.dailyWaterGoal = goalSettings.dailyWaterGoal
        entity.goalCalculationVersion = goalSettings.goalCalculationVersion
        entity.updatedAt = goalSettings.updatedAt
    }

    // MARK: - AppPreferences

    static func toDomain(_ entity: AppPreferencesEntity) -> AppPreferences {
        AppPreferences(
            id: entity.id,
            weightUnit: WeightUnit(rawValue: entity.weightUnitRawValue) ?? .kilograms,
            heightUnit: HeightUnit(rawValue: entity.heightUnitRawValue) ?? .centimeters,
            volumeUnit: VolumeUnit(rawValue: entity.volumeUnitRawValue) ?? .milliliters,
            energyUnit: EnergyUnit(rawValue: entity.energyUnitRawValue) ?? .kilocalories,
            theme: AppTheme(rawValue: entity.themeRawValue) ?? .system,
            mealReminderEnabled: entity.mealReminderEnabled,
            waterReminderEnabled: entity.waterReminderEnabled,
            dailyReminderEnabled: entity.dailyReminderEnabled,
            startOfWeek: Weekday(rawValue: entity.startOfWeekRawValue) ?? .monday,
            preferredHomeTab: HomeTab(rawValue: entity.preferredHomeTabRawValue) ?? .dashboard,
            lastUsedMealSlot: MealSlot(rawValue: entity.lastUsedMealSlotRawValue) ?? .breakfast,
            hapticsEnabled: entity.hapticsEnabled,
            hasCompletedOnboarding: entity.hasCompletedOnboarding,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toEntity(_ appPreferences: AppPreferences) -> AppPreferencesEntity {
        AppPreferencesEntity(
            id: appPreferences.id,
            weightUnitRawValue: appPreferences.weightUnit.rawValue,
            heightUnitRawValue: appPreferences.heightUnit.rawValue,
            volumeUnitRawValue: appPreferences.volumeUnit.rawValue,
            energyUnitRawValue: appPreferences.energyUnit.rawValue,
            themeRawValue: appPreferences.theme.rawValue,
            mealReminderEnabled: appPreferences.mealReminderEnabled,
            waterReminderEnabled: appPreferences.waterReminderEnabled,
            dailyReminderEnabled: appPreferences.dailyReminderEnabled,
            startOfWeekRawValue: appPreferences.startOfWeek.rawValue,
            preferredHomeTabRawValue: appPreferences.preferredHomeTab.rawValue,
            lastUsedMealSlotRawValue: appPreferences.lastUsedMealSlot.rawValue,
            hapticsEnabled: appPreferences.hapticsEnabled,
            hasCompletedOnboarding: appPreferences.hasCompletedOnboarding,
            createdAt: appPreferences.createdAt,
            updatedAt: appPreferences.updatedAt
        )
    }

    static func apply(_ appPreferences: AppPreferences, to entity: AppPreferencesEntity) {
        entity.weightUnitRawValue = appPreferences.weightUnit.rawValue
        entity.heightUnitRawValue = appPreferences.heightUnit.rawValue
        entity.volumeUnitRawValue = appPreferences.volumeUnit.rawValue
        entity.energyUnitRawValue = appPreferences.energyUnit.rawValue
        entity.themeRawValue = appPreferences.theme.rawValue
        entity.mealReminderEnabled = appPreferences.mealReminderEnabled
        entity.waterReminderEnabled = appPreferences.waterReminderEnabled
        entity.dailyReminderEnabled = appPreferences.dailyReminderEnabled
        entity.startOfWeekRawValue = appPreferences.startOfWeek.rawValue
        entity.preferredHomeTabRawValue = appPreferences.preferredHomeTab.rawValue
        entity.lastUsedMealSlotRawValue = appPreferences.lastUsedMealSlot.rawValue
        entity.hapticsEnabled = appPreferences.hapticsEnabled
        entity.hasCompletedOnboarding = appPreferences.hasCompletedOnboarding
        entity.updatedAt = appPreferences.updatedAt
    }
}
