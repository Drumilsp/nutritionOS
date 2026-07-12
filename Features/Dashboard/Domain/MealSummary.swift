//
//  MealSummary.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents today's prepared meal-slot summaries.
struct MealSummary {

    // MARK: - Properties

    let breakfast: MealSummaryItem
    let lunch: MealSummaryItem
    let dinner: MealSummaryItem
    let snack: MealSummaryItem

    var items: [MealSummaryItem] {
        [breakfast, lunch, dinner, snack]
    }
}
