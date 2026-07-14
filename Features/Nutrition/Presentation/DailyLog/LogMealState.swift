import Foundation

enum LogMealState {
    case searching([Meal])
    case editing(Meal)
    case saving
    case saved
    case validationError(String)
    case error(String)
}
