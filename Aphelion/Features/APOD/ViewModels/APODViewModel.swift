import SwiftUI

@Observable
class APODViewModel {
    var isLoading: Bool = false
    var apod: APOD?
    var error: Error?
    private let client: NASAClientProtocol
    
    init(client: NASAClientProtocol) {
        self.client = client
    }
    
    func fetchAPOD(){
        Task{
            isLoading = true
            do{
                apod = try await client.fetchAPOD()
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}
