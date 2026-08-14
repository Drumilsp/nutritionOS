//
//  ProteinCard.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct ProteinCard: View {

    // MARK: - Properties

    let progress: MacroProgress
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Protein", systemImage: "flame.fill")
                        .font(.headline)
                    Spacer()
                    Text(DashboardFormatter.grams(progress.remaining))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                ProgressView(value: DashboardFormatter.percent(current: progress.current, goal: progress.goal))
                    .tint(.red)

                HStack {
                    Text(DashboardFormatter.grams(progress.current))
                    Spacer()
                    Text(DashboardFormatter.grams(progress.goal))
                }
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
