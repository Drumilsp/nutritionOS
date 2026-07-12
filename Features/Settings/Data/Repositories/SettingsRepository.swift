//
//  SettingsRepository.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Provides asynchronous persistence operations for app settings.
protocol SettingsRepository {
    func userProfile() async throws -> UserProfile
    func saveUserProfile(_ userProfile: UserProfile) async throws -> UserProfile
    func goalSettings() async throws -> GoalSettings
    func saveGoalSettings(_ goalSettings: GoalSettings) async throws -> GoalSettings
    func appPreferences() async throws -> AppPreferences
    func saveAppPreferences(_ appPreferences: AppPreferences) async throws -> AppPreferences
}
