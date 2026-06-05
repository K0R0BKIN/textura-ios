import CoreText
import Foundation

enum FontRegistrar {
    static func registerBundledFonts() {
        registerFont(named: "SourceSerif4Web-Black", extension: "ttf")
    }

    private static func registerFont(named name: String, extension fileExtension: String) {
        let urls = [
            Bundle.main.url(forResource: name, withExtension: fileExtension, subdirectory: "Fonts"),
            Bundle.main.url(forResource: name, withExtension: fileExtension)
        ]

        guard let fontURL = urls.compactMap(\.self).first else {
            return
        }

        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}
