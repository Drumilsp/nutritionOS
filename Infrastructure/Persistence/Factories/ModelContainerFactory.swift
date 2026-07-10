//
//  ModelContainerFactory.swift
//  Nutri
//
//  Created by Drumil Patil on 10/07/26.
//

import Foundation
import SwiftData

/// Creates SwiftData model containers from persistence configuration values.
struct ModelContainerFactory {

    // MARK: - Initialization

    /// Creates a stateless model container factory.
    init() { }

    // MARK: - Internal Methods

    /// Creates a configured SwiftData model container.
    func makeModelContainer(
        configuration: PersistenceConfiguration
    ) -> ModelContainer {
        do {
            return try ModelContainer(
                for: Schema([]),
                configurations: [configuration.modelConfiguration]
            )
        } catch {
            fatalError("Failed to initialize persistence container: \(error.localizedDescription)")
        }
    }
}
