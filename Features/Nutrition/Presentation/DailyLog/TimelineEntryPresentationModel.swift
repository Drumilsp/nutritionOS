import Foundation

/// Complete presentation contract for one Today timeline item.
struct TimelineEntryPresentationModel: Identifiable {

    // MARK: - Properties

    let entry: TimelineEntry
    let lastUpdated: Date
    let isEditable: Bool
    let isDeletable: Bool

    var id: UUID { entry.id }
    var timestamp: Date { entry.timestamp }
    var source: LoggedEntrySource? {
        switch entry {
        case .food(let food): return food.source
        case .meal(let meal): return meal.source
        case .water: return nil
        }
    }
    var servingMultiplier: Double {
        switch entry {
        case .food(let food): return food.loggedQuantity / food.referenceQuantity
        case .meal(let meal): return meal.servingMultiplier
        case .water: return 1
        }
    }

    // MARK: - Initialization

    init(entry: TimelineEntry, dailyLog: DailyLog) {
        self.entry = entry
        self.lastUpdated = dailyLog.updatedAt
        self.isEditable = !dailyLog.isCompleted
        self.isDeletable = !dailyLog.isCompleted
    }
}
