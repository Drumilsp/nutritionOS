//
//  DashboardFormatter.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

enum DashboardFormatter {

    // MARK: - Public Methods

    static func calories(_ value: Double) -> String {
        "\(Int(value.rounded())) kcal"
    }

    static func grams(_ value: Double) -> String {
        "\(Int(value.rounded())) g"
    }

    static func milliliters(_ value: Double) -> String {
        "\(Int(value.rounded())) ml"
    }

    static func percent(current: Double, goal: Double) -> Double {
        guard goal > 0 else {
            return 0
        }

        return min(max(current / goal, 0), 1)
    }
}
