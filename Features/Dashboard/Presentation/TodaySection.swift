import SwiftUI

struct TodaySection<Content: View>: View {
    let title: String
    private let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title).font(AppTypography.title)
            AppCard { VStack(alignment: .leading, spacing: AppSpacing.md) { content } }
        }
    }
}
