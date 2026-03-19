import Foundation

class NASAClient: NASAClientProtocol {
    func fetchAPOD() async throws -> APOD {
        print("URL: \(NASAEndpoint.apod.url)")
        let (data, _) = try await URLSession.shared.data(from: NASAEndpoint.apod.url)
        print(String(data: data, encoding: .utf8) ?? "не удалось прочитать")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(APOD.self, from: data)
        return result
    }
}
