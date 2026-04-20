import Foundation

class MarsRoverClient {
    private let apiKey = Bundle.main.infoDictionary?["NASA_API_KEY"] as? String ?? ""
    
    func fetchPhotos(rover: String = "curiosity", sol: Int = 1000, camera: String? = nil) async throws -> [MarsPhoto] {
        var urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=\(sol)&api_key=\(apiKey)"
        if let camera = camera {
            urlString += "&camera=\(camera)"
        }
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        print(String(data: data, encoding: .utf8) ?? "не удалось прочитать")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(MarsRoverResponse.self, from: data).photos
    }
}
