//
//  DashboardViewModel.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var state: DashboardState = .loading
    @Published private(set) var dashboardData: DashboardData?

    var lastUpdated: Date? {
        dashboardData?.lastUpdated
    }

    private let getDashboardDataUseCase: GetDashboardDataUseCase

    // MARK: - Initialization

    init(getDashboardDataUseCase: GetDashboardDataUseCase) {
        self.getDashboardDataUseCase = getDashboardDataUseCase
    }

    // MARK: - Public Methods

    func load() async {
        await loadDashboardData()
    }

    func refresh() async {
        await loadDashboardData()
    }

    // MARK: - Private Methods

    private func loadDashboardData() async {
        if dashboardData == nil {
            state = .loading
        }

        do {
            let data = try await getDashboardDataUseCase.execute()
            dashboardData = data
            state = data.quickActions.isEmpty ? .empty : .loaded
        } catch {
            if dashboardData == nil {
                state = .error(message: "Unable to load Dashboard.")
            } else {
                state = .error(message: "Showing latest available data.")
            }
        }
    }
}
