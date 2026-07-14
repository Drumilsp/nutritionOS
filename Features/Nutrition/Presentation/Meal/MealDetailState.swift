//
//  MealDetailState.swift
//  Nutri
//

import Foundation

enum MealDetailState {
    case loading
    case loaded(Meal)
    case archived(Meal)
    case deleted
    case error(String)
}
