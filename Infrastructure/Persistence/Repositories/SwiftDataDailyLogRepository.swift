//
//  SwiftDataDailyLogRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData-backed implementation of daily log persistence.
@MainActor
final class SwiftDataDailyLogRepository: DailyLogRepository {

    // MARK: - Properties

    private let calendar: Calendar
    private let persistenceManager: PersistenceManager

    // MARK: - Initialization

    init(
        persistenceManager: PersistenceManager,
        calendar: Calendar = .current
    ) {
        self.persistenceManager = persistenceManager
        self.calendar = calendar
    }

    // MARK: - DailyLogRepository

    func todayLog() async throws -> DailyLog {
        let today = startOfDay(for: Date())

        if let entity = try dailyLogEntity(date: today) {
            return DailyLogMapper.toDomain(entity)
        }

        let dailyLog = DailyLog(
            date: today,
            calorieGoalSnapshot: 0,
            proteinGoalSnapshot: 0,
            fatGoalSnapshot: 0,
            fibreGoalSnapshot: 0,
            maintenanceCaloriesSnapshot: 0
        )

        return try await save(dailyLog)
    }

    func log(date: Date) async throws -> DailyLog {
        guard let entity = try dailyLogEntity(date: startOfDay(for: date)) else {
            throw RepositoryError.notFound
        }

        return DailyLogMapper.toDomain(entity)
    }

    func logs(from startDate: Date, to endDate: Date) async throws -> [DailyLog] {
        let startDate = startOfDay(for: startDate)
        let endDate = startOfDay(for: endDate)

        return try dailyLogEntities()
            .filter { $0.date >= startDate && $0.date <= endDate }
            .map(DailyLogMapper.toDomain)
    }

    func save(_ dailyLog: DailyLog) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            let normalizedDate = startOfDay(for: dailyLog.date)

            guard try dailyLogEntity(date: normalizedDate) == nil else {
                throw RepositoryError.alreadyExists
            }

            let entity = DailyLogMapper.toEntity(dailyLog)
            entity.date = normalizedDate
            context.insert(entity)
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func addLoggedFood(_ loggedFood: LoggedFood, to date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            let entity = try existingOrNewDailyLogEntity(date: date)
            entity.loggedFoods.append(DailyLogMapper.toEntity(loggedFood))
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func updateLoggedFood(_ loggedFood: LoggedFood, on date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try dailyLogEntity(date: startOfDay(for: date)) else {
                throw RepositoryError.notFound
            }

            guard let index = entity.loggedFoods.firstIndex(where: { $0.id == loggedFood.id }) else {
                throw RepositoryError.notFound
            }

            entity.loggedFoods[index] = DailyLogMapper.toEntity(loggedFood)
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func removeLoggedFood(id: UUID, from date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try dailyLogEntity(date: startOfDay(for: date)) else {
                throw RepositoryError.notFound
            }

            guard let index = entity.loggedFoods.firstIndex(where: { $0.id == id }) else {
                throw RepositoryError.notFound
            }

            let removedEntity = entity.loggedFoods.remove(at: index)
            context.delete(removedEntity)
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func addLoggedMeal(_ loggedMeal: LoggedMeal, to date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            let entity = try existingOrNewDailyLogEntity(date: date)
            entity.loggedMeals.append(DailyLogMapper.toEntity(loggedMeal))
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func updateLoggedMeal(_ loggedMeal: LoggedMeal, on date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try dailyLogEntity(date: startOfDay(for: date)) else {
                throw RepositoryError.notFound
            }

            guard let index = entity.loggedMeals.firstIndex(where: { $0.id == loggedMeal.id }) else {
                throw RepositoryError.notFound
            }

            entity.loggedMeals[index] = DailyLogMapper.toEntity(loggedMeal)
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func removeLoggedMeal(id: UUID, from date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try dailyLogEntity(date: startOfDay(for: date)) else {
                throw RepositoryError.notFound
            }

            guard let index = entity.loggedMeals.firstIndex(where: { $0.id == id }) else {
                throw RepositoryError.notFound
            }

            let removedEntity = entity.loggedMeals.remove(at: index)
            context.delete(removedEntity)
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func updateWaterIntake(_ waterIntake: Double, on date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            let entity = try existingOrNewDailyLogEntity(date: date)
            entity.waterIntake = waterIntake
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func markDayComplete(date: Date) async throws -> DailyLog {
        let context = persistenceManager.mainContext

        do {
            let entity = try existingOrNewDailyLogEntity(date: date)
            entity.isCompleted = true
            entity.updatedAt = Date()
            try context.save()
            return DailyLogMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func exists(date: Date) async throws -> Bool {
        try dailyLogEntity(date: startOfDay(for: date)) != nil
    }

    // MARK: - Private Methods

    private func existingOrNewDailyLogEntity(date: Date) throws -> DailyLogEntity {
        let normalizedDate = startOfDay(for: date)

        if let entity = try dailyLogEntity(date: normalizedDate) {
            return entity
        }

        let entity = DailyLogMapper.toEntity(
            DailyLog(
                date: normalizedDate,
                calorieGoalSnapshot: 0,
                proteinGoalSnapshot: 0,
                fatGoalSnapshot: 0,
                fibreGoalSnapshot: 0,
                maintenanceCaloriesSnapshot: 0
            )
        )

        persistenceManager.mainContext.insert(entity)
        return entity
    }

    private func dailyLogEntity(date: Date) throws -> DailyLogEntity? {
        let normalizedDate = startOfDay(for: date)
        return try dailyLogEntities().first { $0.date == normalizedDate }
    }

    private func dailyLogEntities() throws -> [DailyLogEntity] {
        let descriptor = FetchDescriptor<DailyLogEntity>()
        return try persistenceManager.mainContext.fetch(descriptor)
    }

    private func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}
