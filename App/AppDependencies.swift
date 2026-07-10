//
//  AppDependencies.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Composition root for long-lived application dependencies.
@MainActor
struct AppDependencies {

    // MARK: - Properties

    /// Owns the app's persistence lifetime.
    let persistenceManager: PersistenceManager

    // MARK: - Initialization

    /// Creates application dependencies for a selected persistence configuration.
    init(
        persistenceConfiguration: PersistenceConfiguration = .production
    ) {
        self.persistenceManager = PersistenceManager(
            configuration: persistenceConfiguration
        )
    }
}
