//
//  GoalCalculationMode.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Determines whether Nutrition OS calculates nutrition targets or preserves manual targets.
enum GoalCalculationMode: String, CaseIterable {
    case automatic
    case manual
}
