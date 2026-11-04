import SwiftUI

struct ArticleView: View {
    let headword: Headword

    var body: some View {
        ScrollView {}
            .navigationTitle(headword.form)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ArticleView(headword: Headword(form: "serendipity"))
    }
}
