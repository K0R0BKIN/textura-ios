import SwiftUI
import CoreText

struct ContentView: View {
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .searchable(text: $query)
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

private struct LogoView: View {
    var body: some View {
        Text("Textura")
            .font(.wordmark(size: 72))
            .tracking(-1.8)
            .foregroundStyle(Color("LogoForeground"))
            .lineLimit(1)
    }
}

private extension Font {
    static func wordmark(size: CGFloat) -> Font {
        let base = CTFontDescriptorCreateWithNameAndSize(
            "SourceSerif4Variable-Roman" as CFString,
            size
        )
        let weighted = CTFontDescriptorCreateCopyWithVariation(
            base,
            NSNumber(value: 0x77676874 as UInt32), // "wght"
            900
        )
        let optical = CTFontDescriptorCreateCopyWithVariation(
            weighted,
            NSNumber(value: 0x6F70737A as UInt32), // "opsz"
            16
        )
        let font = CTFontCreateWithFontDescriptor(optical, size, nil)

        return Font(font)
    }
}

#Preview {
    ContentView()
}
