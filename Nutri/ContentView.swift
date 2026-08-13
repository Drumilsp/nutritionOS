//
//  ContentView.swift
//  Nutri
//
//  Created by Drumil Patil on 10/07/26.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @StateObject private var dashboardViewModel: DashboardViewModel
    @StateObject private var dailyLogViewModel: DailyLogViewModel
    @StateObject private var logFoodViewModel: LogFoodViewModel
    @StateObject private var logMealViewModel: LogMealViewModel
    @StateObject private var logWaterViewModel: LogWaterViewModel
    @State private var foodViewModel: FoodViewModel
    @State private var mealViewModel: MealListViewModel
    @StateObject private var progressViewModel: ProgressViewModel
    @StateObject private var historyViewModel: HistoryViewModel
    @StateObject private var weightHistoryViewModel: WeightHistoryViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var healthSettingsViewModel: HealthSettingsViewModel
    @State private var toastMessage: String?
    private let makeFoodEditorViewModel: (Food, Bool) -> FoodEditorViewModel
    private let makeMealEditorViewModel: (Meal, Bool) -> MealEditorViewModel

    // MARK: - Initialization

    init(dependencies: AppDependencies) {
        _dashboardViewModel = StateObject(wrappedValue: dependencies.makeDashboardViewModel())
        _dailyLogViewModel = StateObject(wrappedValue: dependencies.makeDailyLogViewModel())
        _logFoodViewModel = StateObject(wrappedValue: dependencies.makeLogFoodViewModel())
        _logMealViewModel = StateObject(wrappedValue: dependencies.makeLogMealViewModel())
        _logWaterViewModel = StateObject(wrappedValue: dependencies.makeLogWaterViewModel())
        _foodViewModel = State(initialValue: dependencies.makeFoodViewModel())
        _mealViewModel = State(initialValue: dependencies.makeMealListViewModel())
        _progressViewModel = StateObject(wrappedValue: dependencies.makeProgressViewModel())
        _historyViewModel = StateObject(wrappedValue: dependencies.makeHistoryViewModel())
        _weightHistoryViewModel = StateObject(wrappedValue: dependencies.makeWeightHistoryViewModel())
        _settingsViewModel = StateObject(wrappedValue: dependencies.makeSettingsViewModel())
        _healthSettingsViewModel = StateObject(wrappedValue: dependencies.makeHealthSettingsViewModel())
        self.makeFoodEditorViewModel = dependencies.makeFoodEditorViewModel
        self.makeMealEditorViewModel = dependencies.makeMealEditorViewModel
    }

    // MARK: - Body

    var body: some View {
        AppShellView(
            today: {
                TodayView(
                    dashboardViewModel: dashboardViewModel,
                    dailyLogViewModel: dailyLogViewModel,
                    toastMessage: $toastMessage
                )
            },
            progress: {
                ProgressDashboardView(viewModel: progressViewModel, historyViewModel: historyViewModel, weightHistoryViewModel: weightHistoryViewModel)
            },
            quickLog: {
                QuickLogSheetView(
                    dailyLogViewModel: dailyLogViewModel,
                    logFoodViewModel: logFoodViewModel,
                    logMealViewModel: logMealViewModel,
                    logWaterViewModel: logWaterViewModel,
                    makeFoodEditorViewModel: makeFoodEditorViewModel,
                    makeMealEditorViewModel: makeMealEditorViewModel,
                    onLogCompleted: refreshToday
                )
            },
            settings: {
                SettingsHomeView(viewModel: settingsViewModel, healthViewModel: healthSettingsViewModel)
            },
            foodLibrary: {
                FoodLibraryView(
                    viewModel: foodViewModel,
                    makeFoodEditorViewModel: makeFoodEditorViewModel
                )
            },
            mealLibrary: {
                MealLibraryView(
                    viewModel: mealViewModel,
                    makeMealEditorViewModel: makeMealEditorViewModel,
                    logMeal: logMealFromLibrary
                )
            }
        )
    }

    // MARK: - Private Methods

    private func refreshToday(message: String) {
        toastMessage = message
        Task {
            await dashboardViewModel.refresh()
            await dailyLogViewModel.refresh()
        }
    }

    private func logMealFromLibrary(_ meal: Meal) {
        Task {
            await logMealViewModel.save(mealID: meal.id)
            if case .saved = logMealViewModel.state {
                refreshToday(message: "Meal logged")
            }
        }
    }
}

#Preview {
    ContentView(dependencies: AppDependencies(persistenceConfiguration: .testing))
}
