//
//  EnergyBalanceTarget.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents the energy adjustment applied to today's maintenance calories.
enum EnergyBalanceTarget: String, CaseIterable {
    case deficit
    case maintain
    case surplus

    // MARK: - Properties

    var calorieAdjustment: Double {
        switch self {
        case .deficit:
            return -400
        case .maintain:
            return 0
        case .surplus:
            return 250
        }
    }
}
