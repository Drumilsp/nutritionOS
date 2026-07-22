import SwiftUI

struct LoadingSkeleton: View {
    let height: CGFloat; let cornerRadius: CGFloat
    init(height: CGFloat = 16, cornerRadius: CGFloat = AppRadius.small) { self.height = height; self.cornerRadius = cornerRadius }
    var body: some View { RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(AppColors.skeleton).frame(height: height).redacted(reason: .placeholder).accessibilityHidden(true) }
}
#Preview { VStack { LoadingSkeleton(); LoadingSkeleton(height: 80, cornerRadius: AppRadius.medium) }.padding() }
