//
//  ValidationResult.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents the result of business validation without reducing it to a Bool.
enum ValidationResult: Equatable {
    case success
    case failure([ValidationError])

    // MARK: - Properties

    var errors: [ValidationError] {
        switch self {
        case .success:
            return []
        case .failure(let errors):
            return errors
        }
    }

    // MARK: - Public Methods

    func throwIfInvalid() throws {
        guard case .failure(let errors) = self else {
            return
        }

        throw ValidationFailure(errors: errors)
    }
}
