//
//  UpdateAppPreferencesUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateAppPreferencesUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository
    private let validator: AppPreferencesValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        settingsRepository: any SettingsRepository,
        validator: AppPreferencesValidator = AppPreferencesValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.settingsRepository = settingsRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(_ appPreferences: AppPreferences) async throws -> AppPreferences {
        let updatedPreferences = copy(appPreferences, hasCompletedOnboarding: appPreferences.hasCompletedOnboarding)
        try validator.validate(updatedPreferences).throwIfInvalid()

        return try await settingsRepository.saveAppPreferences(updatedPreferences)
    }

    // MARK: - Private Methods

    private func copy(_ appPreferences: AppPreferences, hasCompletedOnboarding: Bool) -> AppPreferences {
        AppPreferences(
            id: appPreferences.id,
            weightUnit: appPreferences.weightUnit,
            heightUnit: appPreferences.heightUnit,
            volumeUnit: appPreferences.volumeUnit,
            energyUnit: appPreferences.energyUnit,
            theme: appPreferences.theme,
            mealReminderEnabled: appPreferences.mealReminderEnabled,
            waterReminderEnabled: appPreferences.waterReminderEnabled,
            dailyReminderEnabled: appPreferences.dailyReminderEnabled,
            startOfWeek: appPreferences.startOfWeek,
            preferredHomeTab: appPreferences.preferredHomeTab,
            lastUsedMealSlot: appPreferences.lastUsedMealSlot,
            hapticsEnabled: appPreferences.hapticsEnabled,
            hasCompletedOnboarding: hasCompletedOnboarding,
            createdAt: appPreferences.createdAt,
            updatedAt: dateProvider.now
        )
    }
}
