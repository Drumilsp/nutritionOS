import Foundation

enum LogFoodState {
    case searching([Food])
    case editing(Food)
    case saving
    case saved
    case validationError(String)
    case error(String)
}
