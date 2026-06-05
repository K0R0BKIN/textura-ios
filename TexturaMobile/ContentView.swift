import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

private struct HomeView: View {
    @State private var query = ""

    var body: some View {
        NavigationStack {
            SearchableHomeContent()
            .navigationTitle("")
            .toolbar {
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
            }
            .searchable(text: $query, prompt: "Search Textura")
        }
    }
}

private struct SearchableHomeContent: View {
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        ZStack {
            TexturaColor.background
                .ignoresSafeArea()

            if isSearching {
                SearchView()
            } else {
                LogoView()
            }
        }
    }
}

private struct LogoView: View {
    var body: some View {
        VStack {
            Spacer()

            Text("Textura")
                .font(.custom("SourceSerif4-Black", size: 72))
                .tracking(-1.8)
                .foregroundStyle(TexturaColor.foreground)
                .lineLimit(1)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct SearchView: View {
    var body: some View {
        List {
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(TexturaColor.background)
    }
}

private enum TexturaColor {
    static let background = Color(red: 252 / 255, green: 249 / 255, blue: 246 / 255)
    static let foreground = Color(red: 33 / 255, green: 32 / 255, blue: 28 / 255)
}

#Preview {
    ContentView()
}
