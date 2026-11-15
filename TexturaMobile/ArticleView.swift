import SwiftUI

struct ArticleView: View {
    let headword: Headword

    @State private var state: LoadState = .loading

    @ScaledMetric(relativeTo: .largeTitle)
    private var headwordSize: CGFloat = 48

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
            articleContent(article)

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

    private func articleContent(_ article: Article) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                ForEach(article.homographs.indices, id: \.self) {
                    homographIndex in
                    let homograph = article.homographs[homographIndex]
                    let transcriptions = Set(
                        homograph.lexemes.map(\.transcription)
                    )
                    let commonTranscription =
                        transcriptions.count == 1
                        ? transcriptions.first
                        : nil

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading) {
                            let homographNumber = Text(
                                article.homographs.count > 1
                                    ? "\(homographIndex + 1)" : ""
                            )
                            .font(.headword(size: headwordSize * 0.75))
                            .baselineOffset(headwordSize * 0.375)
                            .foregroundColor(Color("SubtleForeground"))

                            let headword = Text(
                                "\(article.headword)\(homographNumber)"
                            )
                            .font(.headword(size: headwordSize))
                            .tracking(-0.025 * headwordSize)
                            .foregroundColor(Color("Foreground"))

                            if let commonTranscription {
                                let transcription = Text(
                                    "/\(commonTranscription)/"
                                )
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .foregroundColor(Color("MutedForeground"))

                                ViewThatFits(in: .horizontal) {
                                    HStack(
                                        alignment: .firstTextBaseline,
                                        spacing: article.homographs.count > 1
                                            ? 8 : 12
                                    ) {
                                        headword
                                        transcription
                                    }
                                    .fixedSize(
                                        horizontal: true,
                                        vertical: false
                                    )

                                    VStack(alignment: .leading, spacing: 8) {
                                        headword
                                        transcription
                                    }
                                }
                                .lineHeight(.tight)
                                .padding(.bottom, 8)
                            } else {
                                headword
                            }

                            Text(homograph.origin)
                                .font(.sourceSerifBody)
                                .foregroundStyle(Color("MutedForeground"))
                        }

                        VStack(alignment: .leading, spacing: 32) {
                            ForEach(homograph.lexemes.indices, id: \.self) {
                                lexemeIndex in
                                let lexeme = homograph.lexemes[lexemeIndex]

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Text(lexeme.lexicalCategory.rawValue)
                                            .foregroundStyle(
                                                Color("SubtleForeground")
                                            )

                                        if commonTranscription == nil {
                                            Text("/\(lexeme.transcription)/")
                                                .fontWeight(.regular)
                                                .foregroundStyle(
                                                    Color("MutedForeground")
                                                )
                                        }
                                    }
                                    .font(.headline)

                                    VStack(alignment: .leading, spacing: 8) {

                                        ForEach(
                                            lexeme.senses.indices,
                                            id: \.self
                                        ) { senseIndex in
                                            let sense = lexeme.senses[
                                                senseIndex
                                            ]

                                            let definition = Text(
                                                sense.definition
                                            )
                                            .fontWeight(.medium)
                                            .foregroundStyle(
                                                Color("Foreground")
                                            )

                                            let colon = Text(":")
                                                .foregroundStyle(
                                                    Color("MutedForeground")
                                                )

                                            let example = Text(sense.example)
                                                .italic()
                                                .foregroundStyle(
                                                    Color("MutedForeground")
                                                )

                                            HStack(
                                                alignment: .firstTextBaseline,
                                                spacing: 8
                                            ) {
                                                Text("\(senseIndex + 1)")
                                                    .foregroundStyle(
                                                        Color("MutedForeground")
                                                    )

                                                Text(
                                                    "\(definition)\(colon) \(example)"
                                                )
                                            }
                                            .font(.sourceSerifBody)
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxWidth: 672)
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("Article") {
    NavigationStack {
        ArticleView(
            headword: Headword(
                form: "bank",
                variety: .enUS
            )
        )
    }
}
