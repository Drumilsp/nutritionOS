import Foundation

enum LogWaterState {
    case idle
    case saving
    case saved
    case validationError(String)
    case error(String)
}
