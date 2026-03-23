import SwiftUI
import SwiftData

@main
struct AphelionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FavoriteAPOD.self)
    }
}
