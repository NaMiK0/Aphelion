import SwiftUI

struct MarsRoverView: View {
    @State private var viewModel = MarsRoverViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Фильтры
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.rovers, id: \.self) { rover in
                            Button {
                                viewModel.selectedRover = rover
                                Task { await viewModel.fetchPhotos() }
                            } label: {
                                Text(rover.capitalized)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(viewModel.selectedRover == rover ? Color.indigo : Color.white.opacity(0.1))
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        
                        Divider().frame(height: 20)
                        
                        Button {
                            viewModel.selectedCamera = nil
                            Task { await viewModel.fetchPhotos() }
                        } label: {
                            Text("Все камеры")
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(viewModel.selectedCamera == nil ? Color.indigo : Color.white.opacity(0.1))
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                        
                        ForEach(viewModel.cameras, id: \.self) { camera in
                            Button {
                                viewModel.selectedCamera = camera
                                Task { await viewModel.fetchPhotos() }
                            } label: {
                                Text(camera)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(viewModel.selectedCamera == camera ? Color.indigo : Color.white.opacity(0.1))
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Галерея
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                        .padding()
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.photos.isEmpty {
                    Spacer()
                    Text("Нет фото для выбранных фильтров")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: MarsPhotoDetailView(photo: photo)) {
                                    CachedAsyncImage(url: URL(string: photo.imgSrc)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                                            .clipped()
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                                            .overlay { ProgressView() }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Марс")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.fetchPhotos() }
            .preferredColorScheme(.dark)
        }
    }
}

// Детальный экран
struct MarsPhotoDetailView: View {
    let photo: MarsPhoto
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: URL(string: photo.imgSrc)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay { ProgressView() }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.rover.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack {
                        Label(photo.camera.fullName, systemImage: "camera")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Марсианский день")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("Sol \(photo.sol)")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Земная дата")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text(photo.earthDate)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
    }
}
