import Foundation

/// Maps recorded weight entries between domain and persistence representations.
enum WeightEntryMapper {
    static func toDomain(_ entity: WeightEntryEntity) -> WeightEntry {
        WeightEntry(id: entity.id, weight: entity.weight, recordedAt: entity.recordedAt, source: WeightEntry.Source(rawValue: entity.sourceRawValue) ?? .manual)
    }

    static func toEntity(_ entry: WeightEntry) -> WeightEntryEntity {
        WeightEntryEntity(id: entry.id, weight: entry.weight, recordedAt: entry.recordedAt, sourceRawValue: entry.source.rawValue)
    }
}
