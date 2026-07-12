//
//  UserProfileValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates and safely normalizes user profile input.
struct UserProfileValidator {

    // MARK: - Public Methods

    func normalizedUserProfile(_ userProfile: UserProfile, updatedAt: Date? = nil) -> UserProfile {
        UserProfile(
            id: userProfile.id,
            name: TextNormalizer.normalizedOptionalText(userProfile.name),
            dateOfBirth: userProfile.dateOfBirth,
            biologicalSex: userProfile.biologicalSex,
            height: userProfile.height,
            currentWeight: userProfile.currentWeight,
            targetWeight: userProfile.targetWeight,
            createdAt: userProfile.createdAt,
            updatedAt: updatedAt ?? userProfile.updatedAt
        )
    }

    func validate(_ userProfile: UserProfile, now: Date = Date()) -> ValidationResult {
        var errors: [ValidationError] = []

        if userProfile.dateOfBirth >= now {
            errors.append(.invalidDateOfBirth)
        }

        if userProfile.height <= 0 || !userProfile.height.isFinite {
            errors.append(.invalidHeight)
        }

        if userProfile.currentWeight <= 0 || !userProfile.currentWeight.isFinite {
            errors.append(.invalidWeight)
        }

        if userProfile.targetWeight <= 0 || !userProfile.targetWeight.isFinite {
            errors.append(.invalidWeight)
        }

        return errors.isEmpty ? .success : .failure(errors)
    }
}
