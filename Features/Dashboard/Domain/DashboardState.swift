//
//  DashboardState.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents the Dashboard loading state without separate Boolean flags.
enum DashboardState: Equatable {
    case loading
    case loaded
    case empty
    case error(message: String)
}
