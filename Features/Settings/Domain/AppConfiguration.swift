//
//  AppConfiguration.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Developer-owned application configuration that is not user editable.
struct AppConfiguration {
    let appVersion: String
    let schemaVersion: Int
    let databaseVersion: Int
    let edition: AppEdition
    let environment: AppEnvironment
    let featureFlags: FeatureFlags
    let defaultValues: DefaultValues
    let healthKitConfiguration: HealthKitConfiguration
    let debugLoggingEnabled: Bool

    static let founderDevelopment = AppConfiguration(
        appVersion: "1.0",
        schemaVersion: 1,
        databaseVersion: 1,
        edition: .founder,
        environment: .development,
        featureFlags: FeatureFlags(),
        defaultValues: DefaultValues(),
        healthKitConfiguration: HealthKitConfiguration(),
        debugLoggingEnabled: true
    )
}

enum AppEdition: String {
    case founder
}

enum AppEnvironment: String {
    case development
    case production
}

struct FeatureFlags {
    let healthKitImportEnabled: Bool
    let notificationsEnabled: Bool

    init(
        healthKitImportEnabled: Bool = false,
        notificationsEnabled: Bool = false
    ) {
        self.healthKitImportEnabled = healthKitImportEnabled
        self.notificationsEnabled = notificationsEnabled
    }
}

struct DefaultValues {
    let dailyWaterGoal: Double
    let goalCalculationVersion: Int

    init(
        dailyWaterGoal: Double = 3_000,
        goalCalculationVersion: Int = 1
    ) {
        self.dailyWaterGoal = dailyWaterGoal
        self.goalCalculationVersion = goalCalculationVersion
    }
}

struct HealthKitConfiguration {
    let canImportWeight: Bool
    let canImportActiveCalories: Bool
    let canImportSteps: Bool
    let canImportWorkouts: Bool
    let canImportSleep: Bool
    let canExportNutrition: Bool

    init(
        canImportWeight: Bool = true,
        canImportActiveCalories: Bool = true,
        canImportSteps: Bool = false,
        canImportWorkouts: Bool = false,
        canImportSleep: Bool = false,
        canExportNutrition: Bool = false
    ) {
        self.canImportWeight = canImportWeight
        self.canImportActiveCalories = canImportActiveCalories
        self.canImportSteps = canImportSteps
        self.canImportWorkouts = canImportWorkouts
        self.canImportSleep = canImportSleep
        self.canExportNutrition = canExportNutrition
    }
}
