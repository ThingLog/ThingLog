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
@available(*, deprecated, renamed: "FrameImageSwiftGen.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias FrameImageTypeAlias = FrameImageSwiftGen.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum SwiftGenFrame {
  internal static let biscuit = FrameImageSwiftGen(name: "biscuit")
  internal static let biscuitBig = FrameImageSwiftGen(name: "biscuitBig")
  internal static let biscuitLine = FrameImageSwiftGen(name: "biscuitLine")
  internal static let circle = FrameImageSwiftGen(name: "circle")
  internal static let circleBig = FrameImageSwiftGen(name: "circleBig")
  internal static let circleLine = FrameImageSwiftGen(name: "circleLine")
  internal static let flower = FrameImageSwiftGen(name: "flower")
  internal static let flowerBig = FrameImageSwiftGen(name: "flowerBig")
  internal static let flowerLine = FrameImageSwiftGen(name: "flowerLine")
  internal static let heart = FrameImageSwiftGen(name: "heart")
  internal static let heartBig = FrameImageSwiftGen(name: "heartBig")
  internal static let heartFrame = FrameImageSwiftGen(name: "heartFrame")
  internal static let heartLine = FrameImageSwiftGen(name: "heartLine")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct FrameImageSwiftGen {
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

internal extension FrameImageSwiftGen.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the FrameImageSwiftGen.image property")
  convenience init?(asset: FrameImageSwiftGen) {
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
