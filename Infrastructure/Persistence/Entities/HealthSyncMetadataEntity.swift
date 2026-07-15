import Foundation
import SwiftData

/// SwiftData representation of a HealthKit synchronization record.
@Model
final class HealthSyncMetadataEntity {
    var id: UUID
    var localID: UUID
    var externalID: String
    var dataTypeRawValue: String
    var lastSyncedAt: Date
    var directionRawValue: String
    var statusRawValue: String

    init(id: UUID = UUID(), localID: UUID, externalID: String, dataType: HealthDataType, lastSyncedAt: Date, direction: HealthSyncDirection, status: HealthSyncStatus) {
        self.id = id
        self.localID = localID
        self.externalID = externalID
        self.dataTypeRawValue = dataType.rawValue
        self.lastSyncedAt = lastSyncedAt
        self.directionRawValue = direction.rawValue
        self.statusRawValue = status.rawValue
    }
}
