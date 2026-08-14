import Foundation

/// Read model for one calendar day in Progress History.
struct ProgressHistoryDay: Identifiable {
    let date: Date
    let log: DailyLog?
    let energyBalance: Double?
    let status: ProgressHistoryDayStatus

    var id: Date { date }
}

enum ProgressHistoryDayStatus: Equatable {
    case onTarget
    case offTarget
    case neutral

    static func classify(energyBalance: Double?, targetRange: ClosedRange<Double>?) -> Self {
        guard let energyBalance, let targetRange else { return .neutral }
        return targetRange.contains(energyBalance) ? .onTarget : .offTarget
    }
}
