import SwiftUI

struct ContentView: View {
    @State private var query = ""

    var body: some View {
        NavigationStack {
            Color("Background")
                .ignoresSafeArea()
        }
        .searchable(text: $query, prompt: "Search Textura")
    }
}

#Preview {
    ContentView()
}
