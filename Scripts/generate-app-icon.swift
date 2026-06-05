import AppKit
import CoreText

struct RGB {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    init(hex: UInt32) {
        red = CGFloat((hex >> 16) & 0xff) / 255
        green = CGFloat((hex >> 8) & 0xff) / 255
        blue = CGFloat(hex & 0xff) / 255
    }

    var nsColor: NSColor {
        NSColor(srgbRed: red, green: green, blue: blue, alpha: 1)
    }
}

let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let fontURL = repoRoot.appendingPathComponent("TexturaMobile/Fonts/SourceSerif4Web-Black.ttf")
let outputURL = repoRoot.appendingPathComponent("AppIconSource")
let assetURL = repoRoot.appendingPathComponent("TexturaMobile/Assets.xcassets/AppIcon.appiconset")

let canvas = CGSize(width: 1024, height: 1024)
let foreground = RGB(hex: 0x21201c) // web --foreground / --gray-12
let background = RGB(hex: 0xfcf9f6) // web --background / --brand-2
let darkForeground = RGB(hex: 0xb4b4b4) // web .dark logo color / --subtle-foreground
let darkBackground = RGB(hex: 0x222222) // web .dark --background / --gray-3

try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)

func registerFont() throws -> String {
    guard
        let provider = CGDataProvider(url: fontURL as CFURL),
        let font = CGFont(provider)
    else {
        throw NSError(domain: "AppIcon", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to load \(fontURL.path)"])
    }

    var error: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
    return font.postScriptName as String? ?? "SourceSerif4-Black"
}

let postScriptName = try registerFont()
guard let font = NSFont(name: postScriptName, size: 770) else {
    throw NSError(domain: "AppIcon", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to create font \(postScriptName)"])
}

func makeContext(alpha: Bool) -> CGContext {
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let alphaInfo: CGImageAlphaInfo = alpha ? .premultipliedLast : .noneSkipLast
    return CGContext(
        data: nil,
        width: Int(canvas.width),
        height: Int(canvas.height),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: alphaInfo.rawValue
    )!
}

func drawT(in context: CGContext, color: RGB) {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color.nsColor
    ]
    let string = NSAttributedString(string: "T", attributes: attributes)
    let line = CTLineCreateWithAttributedString(string)
    let bounds = CTLineGetBoundsWithOptions(line, [.useOpticalBounds])

    context.textMatrix = .identity

    let x = (canvas.width - bounds.width) / 2 - bounds.minX
    let y = (canvas.height - bounds.height) / 2 - bounds.minY - 4
    context.textPosition = CGPoint(x: x, y: y)
    CTLineDraw(line, context)
}

func writePNG(_ image: CGImage, to url: URL) throws {
    let bitmap = NSBitmapImageRep(cgImage: image)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "AppIcon", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to encode PNG \(url.path)"])
    }
    try data.write(to: url, options: .atomic)
}

func renderIcon(background: RGB, foreground: RGB, to url: URL) throws {
    let context = makeContext(alpha: false)
    context.setFillColor(background.nsColor.cgColor)
    context.fill(CGRect(origin: .zero, size: canvas))
    drawT(in: context, color: foreground)
    try writePNG(context.makeImage()!, to: url)
}

func renderForegroundLayer(color: RGB, to url: URL) throws {
    let context = makeContext(alpha: true)
    context.clear(CGRect(origin: .zero, size: canvas))
    drawT(in: context, color: color)
    try writePNG(context.makeImage()!, to: url)
}

func renderBackgroundLayer(color: RGB, to url: URL) throws {
    let context = makeContext(alpha: false)
    context.setFillColor(color.nsColor.cgColor)
    context.fill(CGRect(origin: .zero, size: canvas))
    try writePNG(context.makeImage()!, to: url)
}

func writeSVG(to url: URL) throws {
    let svg = """
    <svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
      <rect width="1024" height="1024" fill="#fcf9f6"/>
      <text x="512" y="731" text-anchor="middle" font-family="Source Serif 4" font-size="770" font-weight="900" fill="#21201c">T</text>
    </svg>
    """
    try svg.write(to: url, atomically: true, encoding: .utf8)
}

try renderIcon(
    background: background,
    foreground: foreground,
    to: assetURL.appendingPathComponent("TexturaAppIcon.png")
)
try renderIcon(
    background: darkBackground,
    foreground: darkForeground,
    to: assetURL.appendingPathComponent("TexturaAppIcon-Dark.png")
)
try renderIcon(
    background: RGB(hex: 0xffffff),
    foreground: RGB(hex: 0x111111),
    to: assetURL.appendingPathComponent("TexturaAppIcon-Tinted.png")
)

try renderBackgroundLayer(
    color: background,
    to: outputURL.appendingPathComponent("textura-icon-background.png")
)
try renderForegroundLayer(
    color: foreground,
    to: outputURL.appendingPathComponent("textura-icon-foreground.png")
)
try renderBackgroundLayer(
    color: darkBackground,
    to: outputURL.appendingPathComponent("textura-icon-background-dark.png")
)
try renderForegroundLayer(
    color: darkForeground,
    to: outputURL.appendingPathComponent("textura-icon-foreground-dark.png")
)
try renderIcon(
    background: background,
    foreground: foreground,
    to: outputURL.appendingPathComponent("textura-icon-flat.png")
)
try renderIcon(
    background: darkBackground,
    foreground: darkForeground,
    to: outputURL.appendingPathComponent("textura-icon-flat-dark.png")
)
try writeSVG(to: outputURL.appendingPathComponent("textura-icon.svg"))

print("Generated Textura app icon artwork using \(postScriptName)")
