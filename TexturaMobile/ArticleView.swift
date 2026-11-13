import SwiftUI

struct ArticleView: View {
    let headword: Headword

    @State private var state: LoadState = .loading

    @ScaledMetric(relativeTo: .largeTitle)
    private var headingSize: CGFloat = 48

    private enum LoadState {
        case loading
        case loaded(Article)
        case notFound
        case failed
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
            .navigationTitle(headword.form)
            .task(id: headword) {
                state = .loading

                do {
                    let article = try await ArticleService.fetch(headword)

                    guard !Task.isCancelled else { return }

                    if let article {
                        state = .loaded(article)
                    } else {
                        state = .notFound
                    }
                } catch {
                    guard !Task.isCancelled else { return }
                    state = .failed
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            ProgressView()

        case .loaded(let article):
            ScrollView {
                Text(article.headword)
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

        case .notFound:
            ContentUnavailableView {
                Text("No article found")
            } description: {
                Text("Try searching for something else.")
            }

        case .failed:
            ContentUnavailableView {
                Text("Couldn’t load this word")
            } description: {
                Text("Something went wrong. Try again.")
            }
        }
    }
}
