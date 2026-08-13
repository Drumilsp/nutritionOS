import Foundation

struct ProgressSummary {
    let cards: [MetricSummaryCard]
    let energyBalance: EnergyBalanceAvailability
}

enum EnergyBalanceAvailability {
    case available(consumedCalories: Double, estimatedBurn: Double, label: String, amount: Double)
    case tdeeNotConfigured
    case activeCaloriesUnavailable
}
