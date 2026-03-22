import SwiftUI

private let imageCache = NSCache<NSURL, UIImage>()

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        VStack{
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            guard let url else { return }

            if let cached = imageCache.object(forKey: url as NSURL) {
                uiImage = cached
                return
            }

            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data) else { return }

            imageCache.setObject(image, forKey: url as NSURL)
            uiImage = image
        }
    }
}
