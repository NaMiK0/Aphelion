struct ISSModel: Codable, Equatable {
    let issPosition: Position
    let timestamp: Int
    let message: String
}

struct Position: Codable, Equatable {
    let latitude: String
    let longitude: String
}
