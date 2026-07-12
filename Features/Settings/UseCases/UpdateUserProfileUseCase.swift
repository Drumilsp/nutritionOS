//
//  UpdateUserProfileUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateUserProfileUseCase {

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

    func execute(_ userProfile: UserProfile) async throws -> UserProfile {
        let normalizedProfile = validator.normalizedUserProfile(userProfile, updatedAt: dateProvider.now)
        try validator.validate(normalizedProfile, now: dateProvider.now).throwIfInvalid()

        return try await settingsRepository.saveUserProfile(normalizedProfile)
    }
}
