//
//  RemoveLoggedFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct RemoveLoggedFoodUseCase {

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

    func execute(id: UUID, date: Date? = nil) async throws -> DailyLog {
        let logDate = date ?? dateProvider.now
        try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()

        return try await dailyLogRepository.removeLoggedFood(id: id, from: logDate)
    }
}
