//
//  AppPreferencesEntity.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of app preferences.
@Model
final class AppPreferencesEntity {

    // MARK: - Properties

    var id: UUID
    var weightUnitRawValue: String
    var heightUnitRawValue: String
    var volumeUnitRawValue: String
    var energyUnitRawValue: String
    var themeRawValue: String
    var mealReminderEnabled: Bool
    var waterReminderEnabled: Bool
    var dailyReminderEnabled: Bool
    var startOfWeekRawValue: String
    var preferredHomeTabRawValue: String
    var lastUsedMealSlotRawValue: String
    var hapticsEnabled: Bool
    var hasCompletedOnboarding: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        weightUnitRawValue: String,
        heightUnitRawValue: String,
        volumeUnitRawValue: String,
        energyUnitRawValue: String,
        themeRawValue: String,
        mealReminderEnabled: Bool,
        waterReminderEnabled: Bool,
        dailyReminderEnabled: Bool,
        startOfWeekRawValue: String,
        preferredHomeTabRawValue: String,
        lastUsedMealSlotRawValue: String,
        hapticsEnabled: Bool,
        hasCompletedOnboarding: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.weightUnitRawValue = weightUnitRawValue
        self.heightUnitRawValue = heightUnitRawValue
        self.volumeUnitRawValue = volumeUnitRawValue
        self.energyUnitRawValue = energyUnitRawValue
        self.themeRawValue = themeRawValue
        self.mealReminderEnabled = mealReminderEnabled
        self.waterReminderEnabled = waterReminderEnabled
        self.dailyReminderEnabled = dailyReminderEnabled
        self.startOfWeekRawValue = startOfWeekRawValue
        self.preferredHomeTabRawValue = preferredHomeTabRawValue
        self.lastUsedMealSlotRawValue = lastUsedMealSlotRawValue
        self.hapticsEnabled = hapticsEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
