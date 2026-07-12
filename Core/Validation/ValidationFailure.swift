//
//  ValidationFailure.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Wraps validation errors so use cases can fail through Swift error handling.
struct ValidationFailure: Error, Equatable {
    let errors: [ValidationError]
}
