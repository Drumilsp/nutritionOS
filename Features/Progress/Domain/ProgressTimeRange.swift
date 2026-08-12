import Foundation

enum ProgressTimeRange: Hashable, Identifiable {
    case today
    case week
    case month
    case year
    case custom(Date, Date)

    static let allCases: [ProgressTimeRange] = [.today, .week, .month, .year]
    static let sevenDays: ProgressTimeRange = .week
    static let thirtyDays: ProgressTimeRange = .month
    static let ninetyDays: ProgressTimeRange = .year
    static let allTime: ProgressTimeRange = .year

    var id: String { title }

    var title: String {
        switch self {
        case .today: "Today"
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        case .custom: "Custom"
        }
    }

    func startDate(relativeTo date: Date, calendar: Calendar = .current) -> Date? {
        switch self {
        case .today: return calendar.startOfDay(for: date)
        case .week: return calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: date))
        case .month: return calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: date))
        case .year: return calendar.date(byAdding: .day, value: -364, to: calendar.startOfDay(for: date))
        case .custom(let start, _): return calendar.startOfDay(for: start)
        }
    }

    var dayCount: Int? {
        switch self { case .today: 1; case .week: 7; case .month: 30; case .year: 365; case .custom: nil }
    }
}
