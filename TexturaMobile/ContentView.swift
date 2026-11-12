import CoreText
import SwiftUI

struct ContentView: View {
    @State private var query = ""
    @State private var path: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .searchable(text: $query)
                .onSubmit(of: .search) {
                    let headword = query.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                    guard !headword.isEmpty else { return }

                    path.append(headword)
                }
                .navigationDestination(for: String.self) { headword in
                    ArticleView(headword: headword)
                }
        }
    }
}

private struct HomeView: View {
    @Environment(\.isSearching) private var isSearching

    var body: some View {
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
        .overlay {
            if isSearching {
                Color("Background")
                    .ignoresSafeArea()
            }
        }
    }
}

private struct ArticleView: View {
    let headword: String

    var body: some View {
        Color("Background")
            .ignoresSafeArea()
            .navigationTitle(headword)
    }
}

private struct LogoView: View {
    var body: some View {
        Text("Textura")
            .font(.wordmark(size: 72))
            .tracking(-1.8)
            .foregroundStyle(Color("LogoForeground"))
            .lineLimit(1)
    }
}

extension Font {
    fileprivate static func wordmark(size: CGFloat) -> Font {
        let base = CTFontDescriptorCreateWithNameAndSize(
            "SourceSerif4Variable-Roman" as CFString,
            size
        )
        let weighted = CTFontDescriptorCreateCopyWithVariation(
            base,
            NSNumber(value: 0x7767_6874 as UInt32),  // "wght"
            900
        )
        let optical = CTFontDescriptorCreateCopyWithVariation(
            weighted,
            NSNumber(value: 0x6F70_737A as UInt32),  // "opsz"
            16
        )
        let font = CTFontCreateWithFontDescriptor(optical, size, nil)

        return Font(font)
    }
}

#Preview {
    ContentView()
}
