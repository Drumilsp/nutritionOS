import Foundation
import Combine

@MainActor
final class LogMealViewModel: ObservableObject {
    @Published private(set) var state: LogMealState = .searching([])
    private let searchMealsUseCase: SearchMealsUseCase
    private let logMealUseCase: LogMealUseCase
    init(searchMealsUseCase: SearchMealsUseCase, logMealUseCase: LogMealUseCase) { self.searchMealsUseCase = searchMealsUseCase; self.logMealUseCase = logMealUseCase }
    func search(query: String) async { do { state = .searching(try await searchMealsUseCase.execute(query: query)) } catch { state = .error(error.localizedDescription) } }
    func save(mealID: UUID, mealPeriod: MealSlot? = nil, timestamp: Date? = nil) async { state = .saving; do { _ = try await logMealUseCase.execute(mealID: mealID, mealSlot: mealPeriod ?? .other, date: timestamp); state = .saved } catch { state = .error(error.localizedDescription) } }
}
