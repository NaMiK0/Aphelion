import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 0.3)
    }
    
    var body: some View {
        TabView{
            Tab("Главная", systemImage: "photo"){
                APODView()
            }
            
            Tab("Избранное", systemImage: "star.square.on.square.fill") {
                FavoritesView()
            }
            
            Tab("ISS", systemImage: "globe") {
                ISSView()
            }
        }
        .tint(Color.indigo)
        
        
    }
}


#Preview {
    ContentView()
}
