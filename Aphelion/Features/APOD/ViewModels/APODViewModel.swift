import SwiftUI

@Observable
class APODViewModel {
    var isLoading: Bool = false
    var apod: APOD?
    var error: Error?
    
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: apod?.date ?? "") else { return apod?.date ?? "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        return outputFormatter.string(from: date)
    }
    
    private let client: NASAClientProtocol
    
    init(client: NASAClientProtocol) {
        self.client = client
    }
    
    func fetchAPOD() async {
        isLoading = true
        do{
            apod = try await client.fetchAPOD()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
