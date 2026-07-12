//
//  UserProfile.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents user identity and body measurements stored in SI units.
final class UserProfile: Identifiable {

    // MARK: - Properties

    let id: UUID
    var name: String?
    var dateOfBirth: Date
    var biologicalSex: BiologicalSex
    var height: Double
    var currentWeight: Double
    var targetWeight: Double
    let createdAt: Date
    var updatedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String? = nil,
        dateOfBirth: Date,
        biologicalSex: BiologicalSex,
        height: Double,
        currentWeight: Double,
        targetWeight: Double,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.biologicalSex = biologicalSex
        self.height = height
        self.currentWeight = currentWeight
        self.targetWeight = targetWeight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
