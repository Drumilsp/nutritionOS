//
//  UpdateWaterIntakeUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateWaterIntakeUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(waterIntake: Double, date: Date? = nil) async throws -> DailyLog {
        try validator.validateWaterIntake(waterIntake).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        if try await dailyLogRepository.exists(date: logDate) {
            try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        }

        return try await dailyLogRepository.updateWaterIntake(waterIntake, on: logDate)
    }
}
