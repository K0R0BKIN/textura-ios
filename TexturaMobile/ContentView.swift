import SwiftUI

struct ContentView: View {
    let searchService: HeadwordSearchService

    @State private var query = ""
    @State private var path: [Headword] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .searchable(text: $query)
                .onSubmit(of: .search) {
                    let form = query.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                    guard !form.isEmpty else { return }

                    path.append(Headword(form: form, variety: .enUS))
                }
                .navigationDestination(for: Headword.self) { headword in
                    ArticleView(headword: headword)
                }
        }
    }
}

private struct HomeView: View {
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack {
                Spacer()

                LogoView()

                Spacer()
                Spacer()
            }
        }
        .overlay {
            if isSearching {
                Color("Background")
                    .ignoresSafeArea()
            }
        }
    }
}

private struct LogoView: View {
    var body: some View {
        Text("Textura")
            .font(.wordmark(size: 72))
            .tracking(-1.8)
            .foregroundStyle(Color("LogoForeground"))
            .lineLimit(1)
    }
}

#Preview {
    ContentView(searchService: try! .live())
}
