import SwiftUI

@MainActor
@Observable
class APODViewModel {
    var isLoading: Bool = false
    var apod: APOD?
    var error: Error?
    var currentDate: Date = Date()
    private var cache: [String: APOD] = [:]
    private let client: NASAClientProtocol

    init(client: NASAClientProtocol, selectDate: Date = Date()) {
        self.client = client
        self.currentDate = selectDate
    }

    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: apod?.date ?? "") else { return apod?.date ?? "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    var currentDateString: String { formatDate(currentDate) }

    func fetchAPOD() async {
        let dateKey = currentDateString
        isLoading = true
        if let cached = cache[dateKey] {
            apod = cached
            isLoading = false
            Task { await prefetchNeighbors() }
            return
        }
        
        do {
            let result = try await client.fetchAPOD(date: dateKey)
            cache[dateKey] = result
            apod = result
        } catch {
            self.error = error
        }
        isLoading = false
        Task { await prefetchNeighbors() }
    }

    func goToPreviousDay() {
        guard let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return }
        currentDate = newDate
        Task { await fetchAPOD() }
    }

    func goToNextDay() {
        guard !Calendar.current.isDateInToday(currentDate) else { return }
        guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { return }
        currentDate = newDate
        Task { await fetchAPOD() }
    }
    
    private func prefetchImage(urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        if URLCache.shared.cachedResponse(for: request) != nil { return }
        
        _ = try? await URLSession.shared.data(from: url)
    }

    func prefetchNeighbors() async {
        var datesToPrefetch: [Date] = []

        if let prev = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
            datesToPrefetch.append(prev)
        }
        if !Calendar.current.isDateInToday(currentDate),
           let next = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            datesToPrefetch.append(next)
        }

        await withTaskGroup(of: (String, APOD)?.self) { group in
            for date in datesToPrefetch {
                let key = formatDate(date)
                guard cache[key] == nil else { continue }
                group.addTask {
                    guard let result = try? await self.client.fetchAPOD(date: key) else { return nil }
                    return (key, result)
                }
            }
            for await entry in group {
                if let (key, result) = entry {
                    cache[key] = result
                    await prefetchImage(urlString: result.url)
                }
            }
        }
    }
}
