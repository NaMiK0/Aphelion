import SwiftUI
import SwiftData

struct IdentifiableDate: Identifiable, Hashable {
    let id = UUID()
    let date: Date
}


struct FavoritesView: View {
    @Query private var favorites: [FavoriteAPOD]
    @Environment(\.modelContext) private var modelContext
    @State private var navigationTo: IdentifiableDate? = nil
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
                                FavoriteCardView(favorite: favorite,
                                                 onDelete: {
                                    modelContext.delete(favorite)
                                },
                                                 onNavigation: {
                                    navigationTo = IdentifiableDate(date: favorite.formattedDate)
                                })
                            }
                        }
                    }
                }
                .navigationDestination(item: $navigationTo) { item in
                    APODView(initialDate: item.date)
                }
            }
        }
    }
}
