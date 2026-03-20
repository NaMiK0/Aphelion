import SwiftUI

@Observable
class APODViewModel {
    var isLoading: Bool = false
    var apod: APOD?
    var error: Error?
    var currentDate: Date
    
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: apod?.date ?? "") else { return apod?.date ?? "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        return outputFormatter.string(from: date)
    }
    
    var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: currentDate)
    }
    
    private let client: NASAClientProtocol
    
    init(client: NASAClientProtocol) {
        self.client = client
        self.currentDate = Date()
    }
    
    func fetchAPOD() async {
        isLoading = true
        do{
            apod = try await client.fetchAPOD(date: currentDateString)
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func goToPreviousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate){
            currentDate = newDate
        }
        
        Task {
            await fetchAPOD()
        }
    }
    
    func goToNextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = newDate
        }
        
        Task {
            await fetchAPOD()
        }
    }
    
    
}
