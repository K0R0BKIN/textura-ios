import AlgoliaSearch

struct HeadwordSearchService {
    private let client: SearchClient

    init(appID: String, apiKey: String) throws {
        client = try SearchClient(appID: appID, apiKey: apiKey)
    }

    func search(_ query: String) async throws -> [HeadwordRecord] {
        let response: SearchResponse<HeadwordRecord> =
            try await client.searchSingleIndex(
                indexName: "headwords",
                searchParams: .searchSearchParamsObject(
                    SearchSearchParamsObject(
                        query: query,
                        hitsPerPage: 5
                    )
                )
            )

        return response.hits
    }
}
