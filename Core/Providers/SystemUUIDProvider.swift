//
//  SystemUUIDProvider.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Production UUID provider backed by Foundation.
struct SystemUUIDProvider: UUIDProvider {
    func makeUUID() -> UUID {
        UUID()
    }
}
