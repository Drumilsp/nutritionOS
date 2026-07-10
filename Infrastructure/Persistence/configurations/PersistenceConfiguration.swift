//
//  PersistenceConfiguration.swift
//  Nutri
//
//  Created by Drumil Patil on 10/07/26.
//

import Foundation
import SwiftData

/// Immutable configuration values used to initialize the persistence layer.
struct PersistenceConfiguration {

    // MARK: - Nested Types

    /// Describes whether a configuration should prepare for CloudKit support.
    enum CloudKitConfiguration {
        case disabled
    }

    // MARK: - Properties

    /// Stable name used for the SwiftData store configuration.
    let storeName: String

    /// Indicates whether SwiftData should keep the store entirely in memory.
    let isStoredInMemoryOnly: Bool

    /// Future-facing CloudKit configuration flag.
    let cloudKitConfiguration: CloudKitConfiguration

    /// SwiftData configuration that can be consumed directly by the model container factory.
    var modelConfiguration: ModelConfiguration {
        ModelConfiguration(storeName, isStoredInMemoryOnly: isStoredInMemoryOnly)
    }

    // MARK: - Initialization

    /// Creates immutable persistence configuration values.
    init(
        storeName: String,
        isStoredInMemoryOnly: Bool,
        cloudKitConfiguration: CloudKitConfiguration = .disabled
    ) {
        precondition(!storeName.isEmpty, "Persistence store name must not be empty.")

        self.storeName = storeName
        self.isStoredInMemoryOnly = isStoredInMemoryOnly
        self.cloudKitConfiguration = cloudKitConfiguration
    }

    // MARK: - Supported Configurations

    /// Configuration for the production on-device persistent store.
    static let production = PersistenceConfiguration(
        storeName: "NutritionOS",
        isStoredInMemoryOnly: false
    )

    /// Configuration for SwiftUI previews and sample data.
    static let preview = PersistenceConfiguration(
        storeName: "NutritionOSPreview",
        isStoredInMemoryOnly: true
    )

    /// Configuration for isolated tests.
    static var testing: PersistenceConfiguration {
        PersistenceConfiguration(
            storeName: "NutritionOSTesting-\(UUID().uuidString)",
            isStoredInMemoryOnly: true
        )
    }
}
