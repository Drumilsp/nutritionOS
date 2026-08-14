//
//  WaterCard.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct WaterCard: View {

    // MARK: - Properties

    let summary: WaterSummary

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Water", systemImage: "drop.fill")
                .font(.headline)
                .foregroundStyle(.cyan)

            ProgressView(value: DashboardFormatter.percent(current: summary.current, goal: summary.goal))
                .tint(.cyan)

            HStack {
                waterValue("Current", summary.current)
                Spacer()
                waterValue("Goal", summary.goal)
                Spacer()
                waterValue("Remaining", summary.remaining)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Private Views

    private func waterValue(_ title: String, _ value: Double) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(DashboardFormatter.milliliters(value))
                .font(.subheadline.weight(.semibold).monospacedDigit())
                .foregroundStyle(.primary)
        }
    }
}
