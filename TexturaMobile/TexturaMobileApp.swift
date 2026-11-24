import SwiftUI

@main
struct TexturaMobileApp: App {
    private let searchService: HeadwordSearchService

    init() {
        do {
            searchService = try .live()
        } catch {
            fatalError("Failed to initialize search: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(searchService: searchService)
        }
    }
}
