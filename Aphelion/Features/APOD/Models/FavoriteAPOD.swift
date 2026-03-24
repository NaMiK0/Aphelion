import SwiftData
import SwiftUI

@Model
class FavoriteAPOD {
    var title: String
    var explanation: String
    var imageURL: String
    var date: String
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self.date) else { return ""}
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }
    
    init(title: String, explanation: String, imageURL: String, date: String) {
        self.title = title
        self.explanation = explanation
        self.imageURL = imageURL
        self.date = date
    }
    
    
    
}
