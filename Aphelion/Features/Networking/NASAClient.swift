import Foundation

class NASAClient {
    func fetchAPOD() async throws -> APOD {
        let (data, _) = try await URLSession.shared.data(from: NASAEndpoint.apod.url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(APOD.self, from: data)
        return result
    }
}
