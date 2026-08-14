import Foundation

/// Read model for one calendar day in Progress History.
struct ProgressHistoryDay: Identifiable {
    let date: Date
    let log: DailyLog?
    let energyBalance: Double?
    let status: ProgressHistoryDayStatus

    var id: Date { date }
}

enum ProgressHistoryDayStatus {
    case onTarget
    case offTarget
    case neutral
}
