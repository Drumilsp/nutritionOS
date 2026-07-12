//
//  MacroCard.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct MacroCard: View {

    // MARK: - Properties

    let summary: MacroSummary
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Macros")
                    .font(.headline)

                macroRow(
                    title: "Carbohydrates",
                    progress: summary.carbohydrates,
                    color: .blue
                )

                macroRow(
                    title: "Fat",
                    progress: summary.fat,
                    color: .green
                )
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private Views

    private func macroRow(
        title: String,
        progress: MacroProgress,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(DashboardFormatter.grams(progress.current)) / \(DashboardFormatter.grams(progress.goal))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: DashboardFormatter.percent(current: progress.current, goal: progress.goal))
                .tint(color)
        }
    }
}
