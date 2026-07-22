import SwiftUI

struct MacroProgressBar: View {
    let title: String
    let current: Double
    let goal: Double
    let tint: Color

    init(title: String, current: Double, goal: Double, tint: Color = AppColors.accent) { self.title = title; self.current = current; self.goal = goal; self.tint = tint }

    private var progress: Double { goal > 0 ? min(max(current / goal, 0), 1) : 0 }
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack { Text(title).font(AppTypography.headline); Spacer(); Text("\(Int(current)) / \(Int(goal))").font(AppTypography.callout).foregroundStyle(AppColors.secondaryText) }
            ProgressView(value: progress).tint(tint).accessibilityLabel(title).accessibilityValue("\(Int(current)) of \(Int(goal))")
        }
    }
}

#Preview { MacroProgressBar(title: "Protein", current: 90, goal: 120, tint: AppColors.success).padding() }
