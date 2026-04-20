import Foundation

struct MarsRoverResponse: Codable {
    let photos: [MarsPhoto]
}

struct MarsPhoto: Codable, Identifiable {
    let id: Int
    let sol: Int
    let imgSrc: String
    let earthDate: String
    let camera: MarsCamera
    let rover: MarsRover
}

struct MarsCamera: Codable {
    let name: String
    let fullName: String
}

struct MarsRover: Codable {
    let name: String
}
