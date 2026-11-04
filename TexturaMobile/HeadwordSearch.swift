import Foundation

enum HeadwordSearch {
    private static let mock: [Headword] = [
        "serendipity",
        "serene",
        "tessellate",
        "text",
        "textbook",
        "textile",
        "textual",
        "texture",
        "context",
        "pretext",
    ].map(Headword.init(form:))

    static func suggestions(for query: String) -> [Headword] {
        let query = query.trimmingCharacters(in: .whitespaces)

        guard !query.isEmpty else { return [] }

        return Array(mock.filter { $0.form.localizedStandardContains(query) }.prefix(5))
    }
}
