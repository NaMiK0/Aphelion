import Foundation

@Observable
@MainActor
class ISSViewModel {
    var issLocation: ISSModel?
    var isLoading: Bool = false
    var error: Error?
    
    private let client = ISSClient()
    private var pollingTask: Task<Void, Never>?
    
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
        } catch {
            self.error = error
        }
    }
}
