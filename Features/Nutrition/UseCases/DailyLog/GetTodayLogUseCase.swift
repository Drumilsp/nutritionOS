//
//  GetTodayLogUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetTodayLogUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider
    private let calendar: Calendar

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider(),
        calendar: Calendar = .current
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func execute() async throws -> DailyLog {
        let today = calendar.startOfDay(for: dateProvider.now)

        if try await dailyLogRepository.exists(date: today) {
            return try await dailyLogRepository.log(date: today)
        }

        let dailyLog = DailyLog(
            id: uuidProvider.makeUUID(),
            date: today,
            calorieGoalSnapshot: 0,
            proteinGoalSnapshot: 0,
            fatGoalSnapshot: 0,
            fibreGoalSnapshot: 0,
            maintenanceCaloriesSnapshot: 0,
            createdAt: dateProvider.now,
            updatedAt: dateProvider.now
        )

        return try await dailyLogRepository.save(dailyLog)
    }
}
