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
            NavigationStack{
                ScrollView{
                    LazyVStack(spacing: 14) {
                        ForEach(favorites) { favorite in
                            NavigationLink(destination: APODView(initialDate: favorite.formattedDate)) {
                                FavoriteCardView(favorite: favorite)
                            }
                        }
                    }
                }
            }
        }
    }
}
