import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab("Главная", systemImage: "photo"){
                APODView()
            }
            
            Tab("Избранное", systemImage: "star.square.on.square.fill") {
                FavoritesView()
            }
        }
        
        
    }
}


#Preview {
    ContentView()
}
