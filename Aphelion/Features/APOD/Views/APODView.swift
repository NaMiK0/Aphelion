import SwiftUI

struct APODView: View {
    @State private var viewModel = APODViewModel(client: NASAClient())
    @State private var dragOffset: CGFloat = 0
    var body: some View {
        ScrollView{
            VStack{
                if !viewModel.isLoading {
                    if let apod = viewModel.apod {
                        AsyncImage(url: URL(string: apod.url)){ image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        } placeholder: {
                            Text("Фотография грузится...")
                                .foregroundStyle(Color.blue)
                                .font(.title2)
                                .padding()
                        }
                        .padding()
                        
                        VStack{
                            HStack{
                                Text(viewModel.formattedDate)
                                    .foregroundStyle(Color.gray)
                                    .font(.footnote)
                                Spacer()
                            }
                            
                            HStack{
                                if let author = apod.copyright {
                                    Text("Автор: \(author)")
                                        .foregroundStyle(Color.gray)
                                        .font(.footnote)
                                    Spacer()
                                }
                            }
                            
                        }
                        .padding([.leading], 16)
                        
                        
                        Text(apod.title)
                            .foregroundStyle(Color.indigo)
                            .font(.title)
                            .padding()
                        
                        Text(apod.explanation)
                            .font(.title3)
                            .padding()
                    }
                }
            }
            .task {
                await viewModel.fetchAPOD()
            }
            .offset(x: dragOffset)
            .simultaneousGesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onChanged{ value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.goToNextDay()
                        }
                    } else if value.translation.width > 100 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.goToPreviousDay()
                        }
                    }
                    dragOffset = 0
                }
                                 
                                 
                                 
            )
        }
        .preferredColorScheme(ColorScheme.dark)
        .overlay{
            if viewModel.isLoading {
                ProgressView()
                    .frame(width: 35, height: 35)
            }
        }
    }
}

