//
//  QuickAction.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

/// Represents an actionable Dashboard shortcut prepared for presentation.
struct QuickAction: Identifiable {

    // MARK: - Properties

    let id: QuickActionKind
    let title: String
    let systemImage: String
}
