import Foundation

/// Presentation-ready representation of one chronological daily log event.
enum TimelineEntry: Identifiable {
    case food(LoggedFood)
    case meal(LoggedMeal)
    case water(WaterEntry)

    var id: UUID { switch self { case .food(let item): item.id; case .meal(let item): item.id; case .water(let item): item.id } }
    var timestamp: Date { switch self { case .food(let item): item.createdAt; case .meal(let item): item.createdAt; case .water(let item): item.timestamp } }
}
