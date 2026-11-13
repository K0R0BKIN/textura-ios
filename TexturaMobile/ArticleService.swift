import Foundation

enum ArticleService {
    static func fetch(_ headword: Headword) async throws -> Article? {
        let url = URL(
            string: "https://textura-umber.vercel.app/api/articles"
        )!
        .appending(component: headword.variety.rawValue.lowercased())
        .appending(component: headword.form)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Article?.self, from: data)
    }
}
