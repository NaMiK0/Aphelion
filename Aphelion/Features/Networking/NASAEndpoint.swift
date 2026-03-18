import Foundation
enum NASAEndpoint{
    case apod
    
    var url: URL {
        switch self {
        case .apod:
            return URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
        }
    }
}


