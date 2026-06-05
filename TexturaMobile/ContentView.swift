import SwiftUI
import UIKit

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
                .tint(TexturaColor.accent)
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
    static let background = Color(
        light: UIColor(red: 252 / 255, green: 249 / 255, blue: 246 / 255, alpha: 1),
        dark: UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
    )

    static let foreground = Color(
        light: UIColor(red: 33 / 255, green: 32 / 255, blue: 28 / 255, alpha: 1),
        dark: UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
    )

    static let accent = Color(
        light: UIColor(red: 173 / 255, green: 127 / 255, blue: 88 / 255, alpha: 1),
        dark: UIColor(red: 173 / 255, green: 127 / 255, blue: 88 / 255, alpha: 1)
    )
}

private extension Color {
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        })
    }
}

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
