import SwiftUI
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
            uiImage = nil
            guard let url else { return }
            guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
            
            uiImage = UIImage(data: data)
        }
    }
}
