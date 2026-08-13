//
//  GoalReminderView.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct GoalReminderView: View {

    // MARK: - Properties

    let message: String

    // MARK: - Body

    var body: some View {
        Label(message, systemImage: "target")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppColors.fat)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.fat.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
