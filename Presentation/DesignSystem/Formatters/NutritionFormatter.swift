import Foundation

enum NutritionFormatter {
    static func energy(_ kilocalories: Double) -> String { "\(kilocalories.formatted(.number.precision(.fractionLength(0)))) kcal" }
    static func macro(_ grams: Double) -> String { "\(grams.formatted(.number.precision(.fractionLength(0...1)))) g" }
}

enum WeightFormatter {
    static func string(_ kilograms: Double) -> String { "\(kilograms.formatted(.number.precision(.fractionLength(1)))) kg" }
}

enum WaterFormatter {
    static func string(_ milliliters: Double) -> String { "\(milliliters.formatted(.number.precision(.fractionLength(0)))) mL" }
}

enum RelativeDateFormatter {
    static func string(from date: Date, relativeTo referenceDate: Date = .now) -> String {
        RelativeDateTimeFormatter().localizedString(for: date, relativeTo: referenceDate)
    }
}
