import SwiftUI

struct ArticleView: View {
    let headword: Headword

    @ScaledMetric(relativeTo: .largeTitle)
    private var headingSize: CGFloat = 48

    var body: some View {
        ScrollView {
            Text(headword.form)
                .font(
                    .sourceSerif(
                        size: headingSize,
                        weight: 600,
                        opticalSize: 16
                    )
                )
                .tracking(-1.2)
                .foregroundStyle(Color("Foreground"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(Color("Background"))
        .navigationTitle(headword.form)
    }
}
