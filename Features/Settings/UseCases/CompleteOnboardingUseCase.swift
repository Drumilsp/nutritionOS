//
//  CompleteOnboardingUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct CompleteOnboardingUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        settingsRepository: any SettingsRepository,
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.settingsRepository = settingsRepository
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute() async throws -> AppPreferences {
        let preferences = try await settingsRepository.appPreferences()
        let updatedPreferences = AppPreferences(
            id: preferences.id,
            weightUnit: preferences.weightUnit,
            heightUnit: preferences.heightUnit,
            volumeUnit: preferences.volumeUnit,
            energyUnit: preferences.energyUnit,
            theme: preferences.theme,
            mealReminderEnabled: preferences.mealReminderEnabled,
            waterReminderEnabled: preferences.waterReminderEnabled,
            dailyReminderEnabled: preferences.dailyReminderEnabled,
            startOfWeek: preferences.startOfWeek,
            preferredHomeTab: preferences.preferredHomeTab,
            lastUsedMealSlot: preferences.lastUsedMealSlot,
            hapticsEnabled: preferences.hapticsEnabled,
            hasCompletedOnboarding: true,
            createdAt: preferences.createdAt,
            updatedAt: dateProvider.now
        )

        return try await settingsRepository.saveAppPreferences(updatedPreferences)
    }
}
