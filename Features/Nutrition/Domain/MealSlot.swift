//
//  MealSlot.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents the eating occasion for logged nutrition entries.
enum MealSlot: String, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack
    case other
}
