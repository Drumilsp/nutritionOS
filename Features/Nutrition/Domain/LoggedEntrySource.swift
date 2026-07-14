import Foundation

/// Identifies how a historical entry was created.
enum LoggedEntrySource: String, CaseIterable {
    case manualFood
    case mealTemplate
    case ai
    case barcode
    case imported
}
