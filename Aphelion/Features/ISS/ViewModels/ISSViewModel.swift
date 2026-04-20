import Foundation
import CoreLocation

@Observable
@MainActor
class ISSViewModel {
    var issLocation: ISSModel?
    var locationName: String = "Определяется..."
    var isLoading: Bool = false
    var error: Error?
    
    private let client = ISSClient()
    private var pollingTask: Task<Void, Never>?
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                if let country = placemark.country {
                    locationName = country
                } else if let ocean = placemark.ocean {
                    locationName = ocean
                } else {
                    locationName = "Неизвестная территория"
                }
            }
        } catch {
            locationName = "Не определено"
        }
    }
    
    func startTracking() {
        pollingTask = Task {
            while !Task.isCancelled {
                await fetchLocation()
                try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 секунд
            }
        }
    }
    
    func stopTracking() {
        pollingTask?.cancel()
        pollingTask = nil
    }
    
    private func fetchLocation() async {
        do {
            issLocation = try await client.fetchISSLocation()
            if let position = issLocation?.issPosition,
               let lat = Double(position.latitude),
               let lon = Double(position.longitude) {
                await reverseGeocode(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
        } catch {
            self.error = error
        }
    }
}
