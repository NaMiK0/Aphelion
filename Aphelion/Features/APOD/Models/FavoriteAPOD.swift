import SwiftData

@Model
class FavoriteAPOD {
    var title: String
    var explanation: String
    var imageURL: String
    var date: String
    
    init(title: String, explanation: String, imageURL: String, date: String) {
        self.title = title
        self.explanation = explanation
        self.imageURL = imageURL
        self.date = date
    }
    
}
