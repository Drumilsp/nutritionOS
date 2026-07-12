//
//  DashboardData.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Immutable data required to render today's Dashboard.
struct DashboardData {

    // MARK: - Properties

    let greeting: String
    let currentDate: Date
    let energySummary: EnergySummary
    let macroSummary: MacroSummary
    let waterSummary: WaterSummary
    let mealSummary: MealSummary
    let quickActions: [QuickAction]
    let goalReminder: String?
    let lastUpdated: Date
}
