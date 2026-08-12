import Foundation

enum ProgressMetric: String, CaseIterable, Identifiable {
    case calories, protein, carbohydrates, fat, fibre, water, weight
    var id: String { rawValue }
}
