//
//  FoodListState.swift
//  Nutri
//

import Foundation

enum FoodListState {
    case loading
    case loaded(FoodListContent)
    case empty
    case error(String)
}

struct FoodListContent {
    let foods: [Food]
    let favorites: [Food]
    let recentlyUsed: [Food]
    let categories: [FoodCategory]
}
