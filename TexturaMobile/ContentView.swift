import SwiftUI

struct ContentView: View {
    let searchService: HeadwordSearchService

    @State private var query = ""
    @State private var path: [Headword] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(query: query, searchService: searchService)
                .searchable(text: $query)
                .toolbarVisibility(.hidden, for: .navigationBar)
                .onSubmit(of: .search) {
                    let trimmedQuery = query.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                    guard !trimmedQuery.isEmpty else { return }

                    path.append(Headword(form: trimmedQuery, variety: .enUS))
                }
                .navigationDestination(for: Headword.self) { headword in
                    ArticleView(headword: headword)
                }
        }
    }
}

private struct HomeView: View {
    let query: String
    let searchService: HeadwordSearchService

    @Environment(\.isSearching) private var isSearching

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack {
                Spacer()
                Spacer()

                LogoView()

                Spacer()
                Spacer()
                Spacer()
            }
        }
        .overlay {
            if isSearching {
                SearchResultsView(
                    query: query,
                    searchService: searchService
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background"))
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
