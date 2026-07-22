import SwiftUI

struct MetricRow: View {
    let title: String
    let value: String
    let systemImage: String?
    let tint: Color

    init(title: String, value: String, systemImage: String? = nil, tint: Color = AppColors.accent) { self.title = title; self.value = value; self.systemImage = systemImage; self.tint = tint }

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            if let systemImage { Image(systemName: systemImage).foregroundStyle(tint).accessibilityHidden(true) }
            Text(title).font(AppTypography.body).foregroundStyle(AppColors.primaryText)
            Spacer(minLength: AppSpacing.sm)
            Text(value).font(AppTypography.headline).foregroundStyle(AppColors.primaryText).multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview { MetricRow(title: "Protein", value: "125 g", systemImage: AppIcons.protein).padding() }
