import SwiftUI

struct DesignSystemPreview: View {
    @State private var text = ""
    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: AppSpacing.lg) {
            AppCard { MetricRow(title: "Energy", value: NutritionFormatter.energy(1840), systemImage: AppIcons.info) }
            MacroProgressBar(title: "Protein", current: 94, goal: 120, tint: AppColors.success)
            HStack { StatusBadge("On track", tone: .success); StatusBadge("Review", tone: .warning) }
            LoadingSkeleton(); NutritionTextField("Note", text: $text, prompt: "Optional")
            PrimaryButton("Primary") {}; SecondaryButton("Secondary") {}; DestructiveButton("Destructive") {}
            EmptyStateView(title: "Nothing here", message: "Reusable empty state.")
            HStack { Spacer(); FloatingActionButton(accessibilityLabel: "Add item") {}; Spacer() }
        }.padding().keyboardAware() }.background(AppColors.background)
    }
}

#Preview("Light") { DesignSystemPreview().preferredColorScheme(.light) }
#Preview("Dark") { DesignSystemPreview().preferredColorScheme(.dark) }
#Preview("Large Type") { DesignSystemPreview().dynamicTypeSize(.accessibility3) }
