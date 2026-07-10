//
//  PersistenceManager.swift
//  Nutri
//
//  Created by Drumil Patil on 10/07/26.
//

import Foundation
import SwiftData

/// Owns the application's SwiftData persistence lifetime.
@MainActor
final class PersistenceManager {

    // MARK: - Properties

    private let modelContainerFactory: ModelContainerFactory

    /// The configured SwiftData model container.
    let modelContainer: ModelContainer

    /// The main SwiftData context used by repository implementations.
    let mainContext: ModelContext

    // MARK: - Initialization

    /// Creates a persistence manager from immutable configuration values.
    init(
        configuration: PersistenceConfiguration,
        modelContainerFactory: ModelContainerFactory = ModelContainerFactory()
    ) {
        self.modelContainerFactory = modelContainerFactory

        let modelContainer = modelContainerFactory.makeModelContainer(
            configuration: configuration
        )

        self.modelContainer = modelContainer
        self.mainContext = ModelContext(modelContainer)
    }
}
