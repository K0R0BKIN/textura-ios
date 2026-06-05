import SwiftUI

struct ContentView: View {
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    LogoView()
                    
                    Spacer()
                    Spacer()
                }
            }
        }
        .searchable(text: $query, prompt: "Search Textura")
    }
}

private struct LogoView: View {
    var body: some View {
        Text("Textura")
            .font(.custom("SourceSerif4Variable-Roman", size: 72))
            .fontWeight(.black)
            .tracking(-1.8)
            .foregroundStyle(Color("LogoForeground"))
            .lineLimit(1)
    }
}

#Preview {
    ContentView()
}
