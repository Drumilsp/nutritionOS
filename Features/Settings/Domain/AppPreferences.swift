//
//  AppPreferences.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents user-editable app behavior preferences.
final class AppPreferences: Identifiable {

    // MARK: - Properties

    let id: UUID
    var weightUnit: WeightUnit
    var heightUnit: HeightUnit
    var volumeUnit: VolumeUnit
    var energyUnit: EnergyUnit
    var theme: AppTheme
    var mealReminderEnabled: Bool
    var waterReminderEnabled: Bool
    var dailyReminderEnabled: Bool
    var startOfWeek: Weekday
    var preferredHomeTab: HomeTab
    var lastUsedMealSlot: MealSlot
    var hapticsEnabled: Bool
    var hasCompletedOnboarding: Bool
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        weightUnit: WeightUnit,
        heightUnit: HeightUnit,
        volumeUnit: VolumeUnit,
        energyUnit: EnergyUnit,
        theme: AppTheme,
        mealReminderEnabled: Bool,
        waterReminderEnabled: Bool,
        dailyReminderEnabled: Bool,
        startOfWeek: Weekday,
        preferredHomeTab: HomeTab,
        lastUsedMealSlot: MealSlot,
        hapticsEnabled: Bool,
        hasCompletedOnboarding: Bool,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.weightUnit = weightUnit
        self.heightUnit = heightUnit
        self.volumeUnit = volumeUnit
        self.energyUnit = energyUnit
        self.theme = theme
        self.mealReminderEnabled = mealReminderEnabled
        self.waterReminderEnabled = waterReminderEnabled
        self.dailyReminderEnabled = dailyReminderEnabled
        self.startOfWeek = startOfWeek
        self.preferredHomeTab = preferredHomeTab
        self.lastUsedMealSlot = lastUsedMealSlot
        self.hapticsEnabled = hapticsEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
