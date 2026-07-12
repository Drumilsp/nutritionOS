//
//  AppPreferencesValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates app preferences.
struct AppPreferencesValidator {

    // MARK: - Public Methods

    func validate(_ appPreferences: AppPreferences) -> ValidationResult {
        if AppTheme.allCases.contains(appPreferences.theme)
            && Weekday.allCases.contains(appPreferences.startOfWeek)
            && HomeTab.allCases.contains(appPreferences.preferredHomeTab)
            && MealSlot.allCases.contains(appPreferences.lastUsedMealSlot) {
            return .success
        }

        return .failure([.invalidPreference])
    }
}
