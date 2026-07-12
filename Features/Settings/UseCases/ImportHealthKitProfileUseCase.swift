//
//  ImportHealthKitProfileUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct ImportHealthKitProfileUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository
    private let validator: UserProfileValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        settingsRepository: any SettingsRepository,
        validator: UserProfileValidator = UserProfileValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.settingsRepository = settingsRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(_ profileImport: HealthKitProfileImport) async throws -> UserProfile {
        let currentProfile = try await settingsRepository.userProfile()
        let updatedProfile = UserProfile(
            id: currentProfile.id,
            name: currentProfile.name,
            dateOfBirth: currentProfile.dateOfBirth,
            biologicalSex: currentProfile.biologicalSex,
            height: profileImport.height ?? currentProfile.height,
            currentWeight: profileImport.currentWeight ?? currentProfile.currentWeight,
            targetWeight: currentProfile.targetWeight,
            createdAt: currentProfile.createdAt,
            updatedAt: dateProvider.now
        )
        try validator.validate(updatedProfile, now: dateProvider.now).throwIfInvalid()

        return try await settingsRepository.saveUserProfile(updatedProfile)
    }
}
