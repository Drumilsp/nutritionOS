//
//  NutriTests.swift
//  NutriTests
//
//  Created by Drumil Patil on 10/07/26.
//

import Testing
import SwiftData
@testable import Nutri

struct NutriTests {

    @Test func productionConfigurationUsesPersistentStorage() {
        let configuration = PersistenceConfiguration.production

        #expect(configuration.storeName == "NutritionOS")
        #expect(configuration.isStoredInMemoryOnly == false)
        #expect(configuration.cloudKitConfiguration == .disabled)
    }

    @Test func previewConfigurationUsesInMemoryStorage() {
        let configuration = PersistenceConfiguration.preview

        #expect(configuration.storeName == "NutritionOSPreview")
        #expect(configuration.isStoredInMemoryOnly == true)
        #expect(configuration.cloudKitConfiguration == .disabled)
    }

    @Test func testingConfigurationUsesIsolatedInMemoryStorage() {
        let firstConfiguration = PersistenceConfiguration.testing
        let secondConfiguration = PersistenceConfiguration.testing

        #expect(firstConfiguration.isStoredInMemoryOnly == true)
        #expect(secondConfiguration.isStoredInMemoryOnly == true)
        #expect(firstConfiguration.storeName != secondConfiguration.storeName)
        #expect(firstConfiguration.cloudKitConfiguration == .disabled)
    }

    @MainActor
    @Test func modelContainerFactoryCreatesTestingContainer() {
        let factory = ModelContainerFactory()
        let container = factory.makeModelContainer(
            configuration: .testing
        )

        #expect(container.schema.entities.isEmpty == false)
    }

    @MainActor
    @Test func persistenceManagerOwnsContainerAndMainContext() {
        let persistenceManager = PersistenceManager(
            configuration: .testing
        )

        #expect(persistenceManager.mainContext.container === persistenceManager.modelContainer)
    }

    @MainActor
    @Test func appDependenciesCreatesPersistenceManager() {
        let dependencies = AppDependencies(
            persistenceConfiguration: .testing
        )

        #expect(dependencies.persistenceManager.mainContext.container === dependencies.persistenceManager.modelContainer)
    }
}
