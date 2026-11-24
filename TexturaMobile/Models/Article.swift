struct Article: Decodable {
    let headword: String
    let variety: Variety
    let homographs: [Homograph]
}

struct Homograph: Decodable {
    let origin: String
    let lexemes: [Lexeme]
}

struct Lexeme: Decodable {
    let lexicalCategory: LexicalCategory
    let transcription: String
    let senses: [Sense]
}

struct Sense: Decodable {
    let definition: String
    let example: String
}

enum LexicalCategory: String, Decodable {
    case noun
    case verb
    case adjective
    case adverb
    case preposition
    case conjunction
    case pronoun
    case determiner
    case interjection
}
