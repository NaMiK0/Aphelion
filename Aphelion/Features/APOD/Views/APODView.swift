import SwiftUI

struct APODView: View {
    @State private var viewModel = APODViewModel(client: NASAClient())
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView()
                    .frame(width: 35, height: 35)
            }
            
            if let apod = viewModel.apod {
                AsyncImage(url: URL(string: apod.url)){ image in
                    image
                } placeholder: {
                    Text("Фотография грузится...")
                        .foregroundStyle(Color.blue)
                        .font(.title2)
                        .padding()
                }
                .frame(width: 300, height: 300)
                .clipped()
                .padding()
                
                Text(apod.title)
                    .foregroundStyle(Color.indigo)
                    .font(.title)
                    .padding()
                
                Text(apod.explanation)
                    .foregroundStyle(Color.black)
                    .font(.title3)
                    .padding()
            }
        }
        .task {
            await viewModel.fetchAPOD()
            print("apod: \(viewModel.apod)")
            print("error: \(viewModel.error)")
        }
    }
}

