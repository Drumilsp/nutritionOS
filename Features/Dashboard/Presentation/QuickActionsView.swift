//
//  QuickActionsView.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct QuickActionsView: View {

    // MARK: - Properties

    let actions: [QuickAction]
    let onActionTapped: (QuickActionKind) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(actions) { action in
                    Button {
                        onActionTapped(action.id)
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: action.systemImage)
                                .font(.title3)
                            Text(action.title)
                                .font(.caption.weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .frame(maxWidth: .infinity, minHeight: 76)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
            }
        }
    }
}
