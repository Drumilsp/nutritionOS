import Foundation

enum ProgressDateRange {
    static func dates(for range: ProgressTimeRange, now: Date, calendar: Calendar) -> (start: Date?, end: Date) {
        (range.startDate(relativeTo: now, calendar: calendar), calendar.startOfDay(for: now))
    }

    static func previousDates(for range: ProgressTimeRange, now: Date, calendar: Calendar) -> (start: Date?, end: Date)? {
        guard let count = range.dayCount, let currentStart = range.startDate(relativeTo: now, calendar: calendar), let start = calendar.date(byAdding: .day, value: -count, to: currentStart), let end = calendar.date(byAdding: .day, value: -1, to: currentStart) else { return nil }
        return (start, end)
    }
}
