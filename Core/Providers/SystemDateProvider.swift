//
//  SystemDateProvider.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Production date provider backed by Foundation.
struct SystemDateProvider: DateProvider {
    var now: Date {
        Date()
    }
}
