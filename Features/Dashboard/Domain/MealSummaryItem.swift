//
//  MealSummaryItem.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents one prepared Dashboard meal row.
struct MealSummaryItem: Identifiable {

    // MARK: - Properties

    let id: MealSlot
    let title: String
    let completionState: MealCompletionState
    let calories: Double?
}
