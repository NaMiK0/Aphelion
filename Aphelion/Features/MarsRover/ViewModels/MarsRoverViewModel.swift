import SwiftUI

@Observable
@MainActor
class MarsRoverViewModel {
    var photos: [MarsPhoto] = []
    var isLoading = false
    var error: Error?
    var selectedRover = "curiosity"
    var selectedCamera: String? = nil
    var sol = 1000
    
    let rovers = ["curiosity", "perseverance", "opportunity"]
    let cameras = ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "NAVCAM"]
    
    private let client = MarsRoverClient()
    
    func fetchPhotos() async {
        isLoading = true
        photos = []
        do {
            photos = try await client.fetchPhotos(
                rover: selectedRover,
                sol: sol,
                camera: selectedCamera
            )
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
