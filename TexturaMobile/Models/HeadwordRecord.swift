nonisolated struct HeadwordRecord: Codable {
    let objectID: String
    let headword: String
    let variety: Variety
    let display: Display

    struct Display: Codable {
        let pronunciation: String
        let meaning: String
    }
}
