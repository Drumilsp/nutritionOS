//
//  SwiftDataSettingsRepository.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation
import SwiftData

/// SwiftData-backed implementation of settings persistence.
@MainActor
final class SwiftDataSettingsRepository: SettingsRepository {

    // MARK: - Properties

    private let persistenceManager: PersistenceManager

    // MARK: - Initialization

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - SettingsRepository

    func userProfile() async throws -> UserProfile {
        if let entity = try userProfileEntities().first {
            return SettingsMapper.toDomain(entity)
        }

        return try await saveUserProfile(defaultUserProfile())
    }

    func saveUserProfile(_ userProfile: UserProfile) async throws -> UserProfile {
        let context = persistenceManager.mainContext

        do {
            if let entity = try userProfileEntities().first {
                SettingsMapper.apply(userProfile, to: entity)
                try context.save()
                return SettingsMapper.toDomain(entity)
            }

            let entity = SettingsMapper.toEntity(userProfile)
            context.insert(entity)
            try context.save()
            return SettingsMapper.toDomain(entity)
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func goalSettings() async throws -> GoalSettings {
        if let entity = try goalSettingsEntities().first {
            return SettingsMapper.toDomain(entity)
        }

        return try await saveGoalSettings(defaultGoalSettings())
    }

    func saveGoalSettings(_ goalSettings: GoalSettings) async throws -> GoalSettings {
        let context = persistenceManager.mainContext

        do {
            if let entity = try goalSettingsEntities().first {
                SettingsMapper.apply(goalSettings, to: entity)
                try context.save()
                return SettingsMapper.toDomain(entity)
            }

            let entity = SettingsMapper.toEntity(goalSettings)
            context.insert(entity)
            try context.save()
            return SettingsMapper.toDomain(entity)
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func appPreferences() async throws -> AppPreferences {
        if let entity = try appPreferencesEntities().first {
            return SettingsMapper.toDomain(entity)
        }

        return try await saveAppPreferences(defaultAppPreferences())
    }

    func saveAppPreferences(_ appPreferences: AppPreferences) async throws -> AppPreferences {
        let context = persistenceManager.mainContext

        do {
            if let entity = try appPreferencesEntities().first {
                SettingsMapper.apply(appPreferences, to: entity)
                try context.save()
                return SettingsMapper.toDomain(entity)
            }

            let entity = SettingsMapper.toEntity(appPreferences)
            context.insert(entity)
            try context.save()
            return SettingsMapper.toDomain(entity)
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    // MARK: - Private Methods

    private func userProfileEntities() throws -> [UserProfileEntity] {
        try persistenceManager.mainContext.fetch(FetchDescriptor<UserProfileEntity>())
    }

    private func goalSettingsEntities() throws -> [GoalSettingsEntity] {
        try persistenceManager.mainContext.fetch(FetchDescriptor<GoalSettingsEntity>())
    }

    private func appPreferencesEntities() throws -> [AppPreferencesEntity] {
        try persistenceManager.mainContext.fetch(FetchDescriptor<AppPreferencesEntity>())
    }

    private func defaultUserProfile() -> UserProfile {
        UserProfile(
            dateOfBirth: Date(timeIntervalSince1970: 631_152_000),
            biologicalSex: .unspecified,
            height: 170,
            currentWeight: 70,
            targetWeight: 70
        )
    }

    private func defaultGoalSettings() -> GoalSettings {
        GoalSettings(
            goalType: .maintainWeight,
            energyBalanceTarget: .maintain,
            goalCalculationMode: .automatic,
            activityLevel: .lightlyActive,
            dailyProteinGoal: 120,
            dailyCarbohydrateGoal: 250,
            dailyFatGoal: 70,
            dailyWaterGoal: 3_000,
            goalCalculationVersion: 1
        )
    }

    private func defaultAppPreferences() -> AppPreferences {
        AppPreferences(
            weightUnit: .kilograms,
            heightUnit: .centimeters,
            volumeUnit: .milliliters,
            energyUnit: .kilocalories,
            theme: .system,
            mealReminderEnabled: false,
            waterReminderEnabled: false,
            dailyReminderEnabled: false,
            startOfWeek: .monday,
            preferredHomeTab: .dashboard,
            lastUsedMealSlot: .breakfast,
            hapticsEnabled: true,
            hasCompletedOnboarding: false
        )
    }
}
