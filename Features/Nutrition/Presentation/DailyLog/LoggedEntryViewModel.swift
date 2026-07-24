import Combine
import Foundation

@MainActor
final class LoggedEntryViewModel: ObservableObject {
    @Published private(set) var state: LoggedEntryState
    @Published private(set) var deletedEntry: TimelineEntry?

    private let deleteLoggedEntryUseCase: DeleteLoggedEntryUseCase
    private let duplicateLoggedEntryUseCase: DuplicateLoggedEntryUseCase
    private let restoreLoggedEntryUseCase: RestoreLoggedEntryUseCase
    private let updateLoggedFoodUseCase: UpdateLoggedFoodUseCase
    private let updateLoggedMealUseCase: UpdateLoggedMealUseCase
    private let updateWaterEntryUseCase: UpdateWaterEntryUseCase

    init(entry: TimelineEntry, deleteLoggedEntryUseCase: DeleteLoggedEntryUseCase, duplicateLoggedEntryUseCase: DuplicateLoggedEntryUseCase, restoreLoggedEntryUseCase: RestoreLoggedEntryUseCase, updateLoggedFoodUseCase: UpdateLoggedFoodUseCase, updateLoggedMealUseCase: UpdateLoggedMealUseCase, updateWaterEntryUseCase: UpdateWaterEntryUseCase) {
        self.state = .viewing(entry)
        self.deleteLoggedEntryUseCase = deleteLoggedEntryUseCase
        self.duplicateLoggedEntryUseCase = duplicateLoggedEntryUseCase
        self.restoreLoggedEntryUseCase = restoreLoggedEntryUseCase
        self.updateLoggedFoodUseCase = updateLoggedFoodUseCase
        self.updateLoggedMealUseCase = updateLoggedMealUseCase
        self.updateWaterEntryUseCase = updateWaterEntryUseCase
    }

    func edit() { if let entry = currentEntry { state = .editing(entry) } }
    func duplicate(entry: TimelineEntry, date: Date) async { do { _ = try await duplicateLoggedEntryUseCase.execute(entry, date: date); state = .viewing(entry) } catch { state = .error(error.localizedDescription) } }
    func delete(entry: TimelineEntry, date: Date) async { do { _ = try await deleteLoggedEntryUseCase.execute(entry, date: date); deletedEntry = entry; state = .deleted } catch { state = .error(error.localizedDescription) } }
    func undoDelete(date: Date) async { guard let deletedEntry else { return }; do { _ = try await restoreLoggedEntryUseCase.execute(deletedEntry, date: date); self.deletedEntry = nil; state = .viewing(deletedEntry) } catch { state = .error(error.localizedDescription) } }

    func saveFood(quantity: Double, mealSlot: MealSlot? = nil, notes: String? = nil, date: Date) async {
        guard case .food(let food)? = currentEntry else { return }
        do { let log = try await updateLoggedFoodUseCase.execute(loggedFood: food, quantity: quantity, mealSlot: mealSlot, date: date, notes: notes); updateState(with: log, entryID: food.id) } catch { state = .error(error.localizedDescription) }
    }

    func saveMeal(mealSlot: MealSlot, servingMultiplier: Double? = nil, notes: String? = nil, date: Date) async {
        guard case .meal(let meal)? = currentEntry else { return }
        do { let log = try await updateLoggedMealUseCase.execute(loggedMeal: meal, mealSlot: mealSlot, servingMultiplier: servingMultiplier, date: date, notes: notes); updateState(with: log, entryID: meal.id) } catch { state = .error(error.localizedDescription) }
    }

    func saveWater(amount: Double, timestamp: Date? = nil, date: Date) async {
        guard case .water(let water)? = currentEntry else { return }
        do { let log = try await updateWaterEntryUseCase.execute(waterEntry: water, amount: amount, timestamp: timestamp, date: date); updateState(with: log, entryID: water.id) } catch { state = .error(error.localizedDescription) }
    }

    private var currentEntry: TimelineEntry? { switch state { case .viewing(let entry), .editing(let entry): return entry; case .deleted, .error: return nil } }
    private func updateState(with log: DailyLog, entryID: UUID) { guard let entry = DailyLogCalculations.timeline(for: log).first(where: { $0.id == entryID }) else { state = .error("Updated entry could not be loaded."); return }; state = .viewing(entry) }
}
