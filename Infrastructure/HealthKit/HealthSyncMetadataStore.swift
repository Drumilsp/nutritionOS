import Foundation
import SwiftData

/// Persists HealthKit record mappings and per-type incremental-sync checkpoints.
@MainActor
final class HealthSyncMetadataStore {
    private let persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager) { self.persistenceManager = persistenceManager }

    func metadata(localID: UUID, dataType: HealthDataType) throws -> HealthSyncMetadata? {
        let descriptor = FetchDescriptor<HealthSyncMetadataEntity>(predicate: #Predicate { $0.localID == localID && $0.dataTypeRawValue == dataType.rawValue })
        return try persistenceManager.mainContext.fetch(descriptor).first.flatMap(HealthSyncMetadataMapper.toDomain)
    }

    func lastSuccessfulSync(for dataType: HealthDataType) throws -> Date? {
        let dataTypeRawValue = dataType.rawValue
        let successRawValue = HealthSyncStatus.success.rawValue
        let descriptor = FetchDescriptor<HealthSyncMetadataEntity>(predicate: #Predicate { $0.dataTypeRawValue == dataTypeRawValue && $0.statusRawValue == successRawValue }, sortBy: [SortDescriptor(\.lastSyncedAt, order: .reverse)])
        return try persistenceManager.mainContext.fetch(descriptor).first?.lastSyncedAt
    }

    func save(localID: UUID, externalID: String, dataType: HealthDataType, direction: HealthSyncDirection, status: HealthSyncStatus) throws {
        if let existing = try entity(localID: localID, dataType: dataType) {
            existing.externalID = externalID
            existing.lastSyncedAt = Date()
            existing.directionRawValue = direction.rawValue
            existing.statusRawValue = status.rawValue
        } else {
            persistenceManager.mainContext.insert(HealthSyncMetadataEntity(localID: localID, externalID: externalID, dataType: dataType, lastSyncedAt: Date(), direction: direction, status: status))
        }
        try persistenceManager.mainContext.save()
    }

    func removeAll() throws {
        try persistenceManager.mainContext.fetch(FetchDescriptor<HealthSyncMetadataEntity>()).forEach(persistenceManager.mainContext.delete)
        try persistenceManager.mainContext.save()
    }

    private func entity(localID: UUID, dataType: HealthDataType) throws -> HealthSyncMetadataEntity? {
        let descriptor = FetchDescriptor<HealthSyncMetadataEntity>(predicate: #Predicate { $0.localID == localID && $0.dataTypeRawValue == dataType.rawValue })
        return try persistenceManager.mainContext.fetch(descriptor).first
    }
}
