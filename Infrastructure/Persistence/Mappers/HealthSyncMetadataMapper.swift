import Foundation

/// Maps HealthKit synchronization metadata between persistence and domain forms.
enum HealthSyncMetadataMapper {
    static func toDomain(_ entity: HealthSyncMetadataEntity) -> HealthSyncMetadata? {
        guard let dataType = HealthDataType(rawValue: entity.dataTypeRawValue), let direction = HealthSyncDirection(rawValue: entity.directionRawValue), let status = HealthSyncStatus(rawValue: entity.statusRawValue) else { return nil }
        return HealthSyncMetadata(id: entity.id, localID: entity.localID, externalID: entity.externalID, dataType: dataType, lastSyncedAt: entity.lastSyncedAt, direction: direction, status: status)
    }
}
