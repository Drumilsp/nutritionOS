//
//  DailyLogRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Provides asynchronous persistence operations for daily nutrition logs.
protocol DailyLogRepository {
    func todayLog() async throws -> DailyLog
    func log(date: Date) async throws -> DailyLog
    func logs(from startDate: Date, to endDate: Date) async throws -> [DailyLog]
    func save(_ dailyLog: DailyLog) async throws -> DailyLog
    func addLoggedFood(_ loggedFood: LoggedFood, to date: Date) async throws -> DailyLog
    func updateLoggedFood(_ loggedFood: LoggedFood, on date: Date) async throws -> DailyLog
    func removeLoggedFood(id: UUID, from date: Date) async throws -> DailyLog
    func addLoggedMeal(_ loggedMeal: LoggedMeal, to date: Date) async throws -> DailyLog
    func updateLoggedMeal(_ loggedMeal: LoggedMeal, on date: Date) async throws -> DailyLog
    func removeLoggedMeal(id: UUID, from date: Date) async throws -> DailyLog
    func updateWaterIntake(_ waterIntake: Double, on date: Date) async throws -> DailyLog
    func markDayComplete(date: Date) async throws -> DailyLog
    func exists(date: Date) async throws -> Bool
}
