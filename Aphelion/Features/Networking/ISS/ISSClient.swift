import Foundation

class ISSClient {
    func fetchISSLocation() async throws -> ISSModel {
        let url = URL(string: "http://api.open-notify.org/iss-now.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ISSModel.self, from: data)
    }
}
