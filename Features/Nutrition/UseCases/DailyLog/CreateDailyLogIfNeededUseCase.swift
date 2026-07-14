import Foundation

/// Lazily creates one daily log with an immutable snapshot of the active goals.
struct CreateDailyLogIfNeededUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let settingsRepository: any SettingsRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar

    init(dailyLogRepository: any DailyLogRepository, settingsRepository: any SettingsRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) {
        self.dailyLogRepository = dailyLogRepository
        self.settingsRepository = settingsRepository
        self.dateProvider = dateProvider
        self.calendar = calendar
    }

    func execute(date: Date? = nil) async throws -> DailyLog {
        let day = calendar.startOfDay(for: date ?? dateProvider.now)
        if try await dailyLogRepository.exists(date: day) { return try await dailyLogRepository.log(date: day) }
        let goals = try await settingsRepository.goalSettings()
        let calories = (goals.dailyProteinGoal * 4) + (goals.dailyCarbohydrateGoal * 4) + (goals.dailyFatGoal * 9)
        return try await dailyLogRepository.save(DailyLog(date: day, calorieGoalSnapshot: calories, proteinGoalSnapshot: goals.dailyProteinGoal, carbohydrateGoalSnapshot: goals.dailyCarbohydrateGoal, fatGoalSnapshot: goals.dailyFatGoal, fibreGoalSnapshot: 0, waterGoalSnapshot: goals.dailyWaterGoal, maintenanceCaloriesSnapshot: calories, createdAt: dateProvider.now, updatedAt: dateProvider.now))
    }
}
