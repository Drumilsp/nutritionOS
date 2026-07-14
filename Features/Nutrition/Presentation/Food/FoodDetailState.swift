//
//  FoodDetailState.swift
//  Nutri
//

import Foundation

enum FoodDetailState {
    case loading
    case loaded(Food)
    case archived(Food)
    case deleted
    case error(String)
}
