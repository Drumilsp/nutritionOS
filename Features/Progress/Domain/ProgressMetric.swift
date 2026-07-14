import Foundation

enum ProgressMetric: String, CaseIterable, Identifiable {
    case calories, protein, carbohydrates, fat, water, weight
    var id: String { rawValue }
}
