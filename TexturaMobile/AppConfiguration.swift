import Foundation

struct AppConfiguration {
    let algoliaAppID: String
    let algoliaSearchAPIKey: String

    enum ConfigurationError: Error {
        case missingValue(String)
    }

    init(bundle: Bundle = .main) throws {
        guard
            let appID = bundle.object(
                forInfoDictionaryKey: "AlgoliaAppID"
            ) as? String,
            !appID.isEmpty
        else {
            throw ConfigurationError.missingValue("AlgoliaAppID")
        }

        guard
            let apiKey = bundle.object(
                forInfoDictionaryKey: "AlgoliaSearchAPIKey"
            ) as? String,
            !apiKey.isEmpty
        else {
            throw ConfigurationError.missingValue("AlgoliaSearchAPIKey")
        }

        algoliaAppID = appID
        algoliaSearchAPIKey = apiKey
    }
}
