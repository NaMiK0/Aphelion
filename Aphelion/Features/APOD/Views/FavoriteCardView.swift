import SwiftUI

struct FavoriteCardView: View {
    @State private var showAlertDelete: Bool = false
    let favorite: FavoriteAPOD
    var onDelete: () -> Void
    var onNavigation: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
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
                
                Button {
                    showAlertDelete = true
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.indigo)
                        .font(.title2)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.title)
                    .foregroundStyle(Color.indigo)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(favorite.formattedDateString)
                    .foregroundStyle(Color.gray)
                    .font(.caption)
                
                Text(favorite.explanation)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(3)
            }
            .padding(14)
        }
        .contextMenu {
            Button (role: .destructive){
                onDelete()
            } label: {
                Text("Удалить")
            }
            
            Button {
                onNavigation()
            } label: {
                Text("Перейти к публикации")
            }
        }
        .alert("Удаление из избранного", isPresented: $showAlertDelete) {
            Button("Удалить", role: .destructive) {
                onDelete()
            }
            
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Вы точно хотите удалить публикацию?")
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
