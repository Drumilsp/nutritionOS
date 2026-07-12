//
//  UserProfileEntity.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation
import SwiftData

/// SwiftData representation of user profile settings.
@Model
final class UserProfileEntity {

    // MARK: - Properties

    var id: UUID
    var name: String?
    var dateOfBirth: Date
    var biologicalSexRawValue: String
    var height: Double
    var currentWeight: Double
    var targetWeight: Double
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID,
        name: String?,
        dateOfBirth: Date,
        biologicalSexRawValue: String,
        height: Double,
        currentWeight: Double,
        targetWeight: Double,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.biologicalSexRawValue = biologicalSexRawValue
        self.height = height
        self.currentWeight = currentWeight
        self.targetWeight = targetWeight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
