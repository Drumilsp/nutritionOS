import Foundation

/// Enumerates modal flows owned by the application shell.
enum AppSheetDestination: Identifiable {
    case quickLog
    case createFood
    case createMeal

    // MARK: - Identity

    var id: Self { self }
}
