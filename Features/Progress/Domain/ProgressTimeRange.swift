import Foundation

enum ProgressTimeRange: CaseIterable, Identifiable {
    case sevenDays
    case thirtyDays
    case ninetyDays
    case allTime

    var id: Self { self }

    func startDate(relativeTo date: Date, calendar: Calendar = .current) -> Date? {
        switch self {
        case .sevenDays: return calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: date))
        case .thirtyDays: return calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: date))
        case .ninetyDays: return calendar.date(byAdding: .day, value: -89, to: calendar.startOfDay(for: date))
        case .allTime: return nil
        }
    }

    var dayCount: Int? {
        switch self { case .sevenDays: 7; case .thirtyDays: 30; case .ninetyDays: 90; case .allTime: nil }
    }
}
