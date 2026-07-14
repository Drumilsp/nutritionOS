//
//  MealEditorState.swift
//  Nutri
//

import Foundation

enum MealEditorState {
    case editing(Meal)
    case saving
    case saved(Meal)
    case validationError([ValidationError])
    case error(String)
}
