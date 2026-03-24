import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query private var favorites: [FavoriteAPOD]
    
    var body: some View {
        if favorites.isEmpty {
            VStack{
                Spacer()
                Text("У вас пока нет избранных публикаций")
                    .foregroundStyle(Color.indigo)
                    .font(.title3)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
            }
        } else {
            ScrollView{
                LazyVStack(spacing: 14) {
                    ForEach(favorites) { favorite in
                        VStack(alignment: .leading, spacing: 0) {
                            CachedAsyncImage(url: URL(string: favorite.imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 180)
                                    .clipped()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 180)
                                    .overlay {
                                        ProgressView()
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(favorite.title)
                                    .foregroundStyle(Color.indigo)
                                    .font(.headline)
                                    .lineLimit(2)
                                
                                Text(favorite.date)
                                    .foregroundStyle(Color.gray)
                                    .font(.caption)
                                
                                Text(favorite.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                    .lineLimit(3)
                            }
                            .padding(14)
                        }
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.indigo.opacity(0.9), lineWidth: 0.5)
                        }
                        .shadow(color: Color.indigo.opacity(0.4), radius: 12, x: 4, y: 8)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                    }
                }
            }
        }
    }
}
