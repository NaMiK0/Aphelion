import Foundation
enum NASAEndpoint{
    case apod(date: String?)
    
    var url: URL {
        switch self {
        case .apod(let date):
            let dateParam = date.map {"&date=\($0)"} ?? ""
            return URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(Bundle.main.infoDictionary?["NASA_API_KEY"] as? String ?? "")\(dateParam)")!
            
        }
    
        
    }
}


