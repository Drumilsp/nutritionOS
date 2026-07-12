//
//  WaterSummary.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents today's prepared water progress.
struct WaterSummary {

    // MARK: - Properties

    let current: Double
    let goal: Double
    let remaining: Double
    let quickAddAmounts: [Double]
}
