//
//  EnergyHeroCard.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct EnergyHeroCard: View {

    // MARK: - Properties

    let summary: EnergySummary
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Remaining")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(DashboardFormatter.calories(summary.remainingCalories))
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                    }

                    Spacer()

                    Image(systemName: "bolt.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                }

                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                    GridRow {
                        energyValue("Target", summary.targetCalories)
                        energyValue("Food", summary.foodCalories)
                    }
                    GridRow {
                        energyValue("Burned", summary.caloriesBurned)
                        energyValue("Maintenance", summary.maintenanceCalories)
                    }
                }

                HStack(spacing: 12) {
                    Label(DashboardFormatter.calories(summary.restingCalories), systemImage: "bed.double.fill")
                    Label(DashboardFormatter.calories(summary.activeCalories), systemImage: "figure.run")
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private Views

    private func energyValue(_ title: String, _ value: Double) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(DashboardFormatter.calories(value))
                .font(.headline)
                .foregroundStyle(.primary)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
