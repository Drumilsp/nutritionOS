//
//  ActivityLevel.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Fallback activity level used only when HealthKit active calories are unavailable.
enum ActivityLevel: String, CaseIterable {
    case sedentary
    case lightlyActive
    case moderatelyActive
    case veryActive

    // MARK: - Properties

    var multiplier: Double {
        switch self {
        case .sedentary:
            return 1.2
        case .lightlyActive:
            return 1.375
        case .moderatelyActive:
            return 1.55
        case .veryActive:
            return 1.725
        }
    }
}
