import Foundation
import SwiftData

/// SwiftData-backed implementation of recorded body-weight persistence.
@MainActor
final class SwiftDataWeightRepository: WeightRepository {
    private let persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    func save(_ entry: WeightEntry) async throws -> WeightEntry {
        guard entry.weight > 0, entry.weight.isFinite else { throw RepositoryError.persistenceFailure }
        let context = persistenceManager.mainContext
        do {
            context.insert(WeightEntryMapper.toEntity(entry))
            try context.save()
            return entry
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func entries(from startDate: Date?, to endDate: Date?) async throws -> [WeightEntry] {
        do {
            let descriptor = FetchDescriptor<WeightEntryEntity>(sortBy: [SortDescriptor(\.recordedAt)])
            return try persistenceManager.mainContext.fetch(descriptor)
                .filter { entity in
                    let isAfterStart = startDate.map { entity.recordedAt >= $0 } ?? true
                    let isBeforeEnd = endDate.map { entity.recordedAt <= $0 } ?? true
                    return isAfterStart && isBeforeEnd
                }
                .map(WeightEntryMapper.toDomain)
        } catch {
            throw RepositoryError.persistenceFailure
        }
    }

    func latest() async throws -> WeightEntry? {
        try await entries(from: nil, to: nil).max(by: { $0.recordedAt < $1.recordedAt })
    }

    func delete(id: UUID) async throws {
        do {
            let descriptor = FetchDescriptor<WeightEntryEntity>(predicate: #Predicate { $0.id == id })
            guard let entity = try persistenceManager.mainContext.fetch(descriptor).first else { throw RepositoryError.notFound }
            persistenceManager.mainContext.delete(entity)
            try persistenceManager.mainContext.save()
        } catch let error as RepositoryError {
            throw error
        } catch {
            throw RepositoryError.persistenceFailure
        }
    }

    func deleteAllEntries() async throws {
        do {
            try persistenceManager.mainContext.fetch(FetchDescriptor<WeightEntryEntity>()).forEach(persistenceManager.mainContext.delete)
            try persistenceManager.mainContext.save()
        } catch {
            persistenceManager.mainContext.rollback()
            throw RepositoryError.persistenceFailure
        }
    }
}
