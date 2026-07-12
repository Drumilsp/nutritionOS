//
//  DateProvider.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Supplies dates to business logic for deterministic testing.
protocol DateProvider {
    var now: Date { get }
}
