import Foundation

struct ProgressChartPoint: Identifiable {
    let date: Date
    let value: Double
    var id: Date { date }
}

struct ProgressChartDataset {
    let metric: ProgressMetric
    let points: [ProgressChartPoint]
}
