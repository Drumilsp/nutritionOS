//
//  GetGoalSettingsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetGoalSettingsUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository

    // MARK: - Initialization

    init(settingsRepository: any SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    // MARK: - Public Methods

    func execute() async throws -> GoalSettings {
        try await settingsRepository.goalSettings()
    }
}
