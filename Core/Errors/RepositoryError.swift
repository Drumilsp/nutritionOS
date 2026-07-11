//
//  RepositoryError.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents repository-layer failures without exposing framework-specific errors.
enum RepositoryError: Error {
    case notFound
    case alreadyExists
    case persistenceFailure
    case validationFailed
    case unknown
}
