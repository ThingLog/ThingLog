// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageSwiftGen.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageSwiftGen.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum SwiftGenAssets {
  internal static let back = ImageSwiftGen(name: "back")
  internal static let bought = ImageSwiftGen(name: "bought")
  internal static let camera = ImageSwiftGen(name: "camera")
  internal static let chevronDown = ImageSwiftGen(name: "chevronDown")
  internal static let chevronRight = ImageSwiftGen(name: "chevronRight")
  internal static let chevronUp = ImageSwiftGen(name: "chevronUp")
  internal static let clear = ImageSwiftGen(name: "clear")
  internal static let closeBadge = ImageSwiftGen(name: "closeBadge")
  internal static let closeBig = ImageSwiftGen(name: "closeBig")
  internal static let easyLookTab = ImageSwiftGen(name: "easyLookTab")
  internal static let gift = ImageSwiftGen(name: "gift")
  internal static let homeTab = ImageSwiftGen(name: "homeTab")
  internal static let modifyText = ImageSwiftGen(name: "modifyText")
  internal static let paddingBack = ImageSwiftGen(name: "paddingBack")
  internal static let plusTab = ImageSwiftGen(name: "plusTab")
  internal static let question = ImageSwiftGen(name: "question")
  internal static let rating = ImageSwiftGen(name: "rating")
  internal static let search = ImageSwiftGen(name: "search")
  internal static let setting = ImageSwiftGen(name: "setting")
  internal static let textdelete = ImageSwiftGen(name: "textdelete")
  internal static let wish = ImageSwiftGen(name: "wish")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageSwiftGen {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageSwiftGen.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageSwiftGen.image property")
  convenience init?(asset: ImageSwiftGen) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
