//
//  FoodEditorState.swift
//  Nutri
//

import Foundation

enum FoodEditorState {
    case editing(Food)
    case saving
    case saved(Food)
    case validationError([ValidationError])
    case error(String)
}
