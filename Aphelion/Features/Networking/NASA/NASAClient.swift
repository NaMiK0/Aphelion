import Foundation

class NASAClient: NASAClientProtocol {

    func fetchAPOD(date: String) async throws -> APOD {
        let (data, _) = try await URLSession.shared.data(from: NASAEndpoint.apod(date: date).url)
        print(String(data: data, encoding: .utf8) ?? "не удалось прочитать")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(APOD.self, from: data)
        return result
    }
}
