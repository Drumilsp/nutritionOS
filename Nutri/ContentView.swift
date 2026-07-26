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
    @State private var foodViewModel: FoodViewModel
    @State private var toastMessage: String?
    private let makeFoodEditorViewModel: (Food, Bool) -> FoodEditorViewModel

    // MARK: - Initialization

    init(dependencies: AppDependencies) {
        _dashboardViewModel = StateObject(wrappedValue: dependencies.makeDashboardViewModel())
        _dailyLogViewModel = StateObject(wrappedValue: dependencies.makeDailyLogViewModel())
        _logFoodViewModel = StateObject(wrappedValue: dependencies.makeLogFoodViewModel())
        _logMealViewModel = StateObject(wrappedValue: dependencies.makeLogMealViewModel())
        _foodViewModel = State(initialValue: dependencies.makeFoodViewModel())
        self.makeFoodEditorViewModel = dependencies.makeFoodEditorViewModel
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
            quickLog: {
                QuickLogSheetView(
                    dailyLogViewModel: dailyLogViewModel,
                    logFoodViewModel: logFoodViewModel,
                    logMealViewModel: logMealViewModel,
                    makeFoodEditorViewModel: makeFoodEditorViewModel,
                    onLogCompleted: refreshToday
                )
            },
            settings: {
                ManageFoodsSettingsView()
            },
            foodLibrary: {
                FoodLibraryView(
                    viewModel: foodViewModel,
                    makeFoodEditorViewModel: makeFoodEditorViewModel
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
}

#Preview {
    ContentView(dependencies: AppDependencies(persistenceConfiguration: .testing))
}
