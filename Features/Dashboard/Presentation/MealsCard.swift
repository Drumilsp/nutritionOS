//
//  MealsCard.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct MealsCard: View {

    // MARK: - Properties

    let summary: MealSummary
    let onMealTapped: (MealSlot) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Meals")
                .font(.headline)

            ForEach(summary.items) { item in
                Button {
                    onMealTapped(item.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: iconName(for: item.completionState))
                            .foregroundStyle(color(for: item.completionState))
                            .frame(width: 22)

                        Text(item.title)
                            .font(.subheadline.weight(.semibold))

                        Spacer()

                        Text(caloriesText(for: item))
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if item.id != summary.items.last?.id {
                    Divider()
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Private Methods

    private func iconName(for state: MealCompletionState) -> String {
        switch state {
        case .notLogged:
            return "circle"
        case .logged:
            return "checkmark.circle.fill"
        }
    }

    private func color(for state: MealCompletionState) -> Color {
        switch state {
        case .notLogged:
            return .secondary
        case .logged:
            return .green
        }
    }

    private func caloriesText(for item: MealSummaryItem) -> String {
        guard let calories = item.calories else {
            return "Not logged"
        }

        return DashboardFormatter.calories(calories)
    }
}
