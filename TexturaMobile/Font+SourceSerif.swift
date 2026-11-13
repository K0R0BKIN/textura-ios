import CoreText
import SwiftUI

extension Font {
    static func sourceSerif(
        size: CGFloat,
        weight: CGFloat,
        opticalSize: CGFloat
    ) -> Font {
        let base = CTFontDescriptorCreateWithNameAndSize(
            "SourceSerif4Roman-Regular" as CFString,
            size
        )
        let weighted = CTFontDescriptorCreateCopyWithVariation(
            base,
            NSNumber(value: 0x7767_6874 as UInt32),  // "wght"
            weight
        )
        let optical = CTFontDescriptorCreateCopyWithVariation(
            weighted,
            NSNumber(value: 0x6F70_737A as UInt32),  // "opsz"
            opticalSize
        )

        return Font(CTFontCreateWithFontDescriptor(optical, size, nil))
    }

    static func wordmark(size: CGFloat) -> Font {
        sourceSerif(size: size, weight: 900, opticalSize: 16)
    }
}
