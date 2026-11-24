nonisolated struct HeadwordRecord: Codable, Identifiable {
    let objectID: String
    let headword: String
    let variety: Variety
    let display: Display

    var id: String { objectID }

    struct Display: Codable {
        let pronunciation: String
        let meaning: String
    }
}
