//
//  DashboardView.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct DashboardView: View {

    // MARK: - Properties

    @StateObject private var viewModel: DashboardViewModel
    @Environment(\.scenePhase) private var scenePhase

    private let onEnergyTapped: () -> Void
    private let onNutritionTapped: () -> Void
    private let onMealTapped: (MealSlot) -> Void
    private let onQuickActionTapped: (QuickActionKind) -> Void

    // MARK: - Initialization

    init(
        viewModel: DashboardViewModel,
        onEnergyTapped: @escaping () -> Void = {},
        onNutritionTapped: @escaping () -> Void = {},
        onMealTapped: @escaping (MealSlot) -> Void = { _ in },
        onQuickActionTapped: @escaping (QuickActionKind) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onEnergyTapped = onEnergyTapped
        self.onNutritionTapped = onNutritionTapped
        self.onMealTapped = onMealTapped
        self.onQuickActionTapped = onQuickActionTapped
    }

    // MARK: - Body

    var body: some View {
        Group {
            if let dashboardData = viewModel.dashboardData {
                dashboardContent(dashboardData)
            } else {
                placeholderContent
            }
        }
        .task {
            await viewModel.load()
        }
        .onChange(of: scenePhase) { _, newValue in
            guard newValue == .active else {
                return
            }

            Task {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Private Views

    private func dashboardContent(_ dashboardData: DashboardData) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DashboardHeaderView(data: dashboardData)

                if case let .error(message) = viewModel.state {
                    DashboardStatusBanner(message: message)
                }

                EnergyHeroCard(
                    summary: dashboardData.energySummary,
                    action: onEnergyTapped
                )

                ProteinCard(
                    progress: dashboardData.macroSummary.protein,
                    action: onNutritionTapped
                )

                MacroCard(
                    summary: dashboardData.macroSummary,
                    action: onNutritionTapped
                )

                WaterCard(summary: dashboardData.waterSummary)

                MealsCard(
                    summary: dashboardData.mealSummary,
                    onMealTapped: onMealTapped
                )

                if let goalReminder = dashboardData.goalReminder {
                    GoalReminderView(message: goalReminder)
                }

                QuickActionsView(
                    actions: dashboardData.quickActions,
                    onActionTapped: onQuickActionTapped
                )
            }
            .padding(20)
        }
        .background(AppColors.background)
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var placeholderContent: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading Dashboard")
        case .empty:
            ContentUnavailableView("Dashboard Empty", systemImage: "rectangle.grid.1x2")
        case let .error(message):
            ContentUnavailableView(message, systemImage: "exclamationmark.triangle")
        case .loaded:
            EmptyView()
        }
    }
}
