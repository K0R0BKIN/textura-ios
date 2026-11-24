import SwiftUI

struct SearchResultsView: View {
    let query: String
    let searchService: HeadwordSearchService

    @State private var results: [HeadwordRecord] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(results) { result in
                    NavigationLink(
                        value: Headword(
                            form: result.headword,
                            variety: result.variety
                        )
                    ) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(result.headword)
                                    .foregroundStyle(Color("Foreground"))

                                Text(result.display.pronunciation)
                                    .font(.subheadline)
                                    .foregroundStyle(Color("MutedForeground"))
                            }

                            Text(result.display.meaning)
                                .font(.subheadline)
                                .foregroundStyle(Color("MutedForeground"))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                    }
                }
            }
            .padding(.horizontal)
            .task(id: query) {
                results = []

                guard query.contains(where: { $0.isLetter || $0.isNumber })
                else {
                    return
                }

                guard let hits = try? await searchService.search(query),
                    !Task.isCancelled
                else {
                    return
                }

                results = hits
            }
        }
        .safeAreaBar(edge: .top) {
            Text("Search")
                .font(.title2.weight(.medium))
                .foregroundStyle(Color("Foreground"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .accessibilityAddTraits(.isHeader)
        }
    }
}
