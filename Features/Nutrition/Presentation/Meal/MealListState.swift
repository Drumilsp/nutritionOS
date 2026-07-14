//
//  MealListState.swift
//  Nutri
//

import Foundation

enum MealListState {
    case loading
    case loaded(MealListContent)
    case empty
    case error(String)
}

struct MealListContent {
    let meals: [Meal]
    let favorites: [Meal]
    let recentlyUsed: [Meal]
}
