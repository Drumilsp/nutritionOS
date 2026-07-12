//
//  PreferenceOptions.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

enum WeightUnit: String, CaseIterable {
    case kilograms
    case pounds
}

enum HeightUnit: String, CaseIterable {
    case centimeters
    case feetAndInches
}

enum VolumeUnit: String, CaseIterable {
    case milliliters
    case fluidOunces
}

enum EnergyUnit: String, CaseIterable {
    case kilocalories
}

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
}

enum Weekday: String, CaseIterable {
    case sunday
    case monday
}

enum HomeTab: String, CaseIterable {
    case dashboard
    case nutrition
    case history
    case settings
}
