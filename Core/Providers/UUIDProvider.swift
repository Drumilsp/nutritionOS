//
//  UUIDProvider.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Supplies UUIDs to business logic for deterministic testing.
protocol UUIDProvider {
    func makeUUID() -> UUID
}
