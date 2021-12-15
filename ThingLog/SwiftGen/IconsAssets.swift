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
@available(*, deprecated, renamed: "IconImageSwiftGen.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias IconImageTypeAlias = IconImageSwiftGen.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum SwiftGenIcons {
  internal static let carouselIcon = IconImageSwiftGen(name: "Carousel Icon")
  internal static let comments = IconImageSwiftGen(name: "Comments")
  internal static let displayCaseNoneM = IconImageSwiftGen(name: "Display case_none(m)")
  internal static let displayCaseNoneS = IconImageSwiftGen(name: "Display case_none(s)")
  internal static let group = IconImageSwiftGen(name: "Group")
  internal static let new = IconImageSwiftGen(name: "NEW")
  internal static let satisfactionFill = IconImageSwiftGen(name: "Satisfaction_fill")
  internal static let satisfactionStroke = IconImageSwiftGen(name: "Satisfaction_stroke")
  internal static let thingLog = IconImageSwiftGen(name: "ThingLog")
  internal static let arrowDropDown = IconImageSwiftGen(name: "arrow_drop_down")
  internal static let buyVer1 = IconImageSwiftGen(name: "buy.ver1")
  internal static let camera = IconImageSwiftGen(name: "camera")
  internal static let cardLogo = IconImageSwiftGen(name: "cardLogo")
  internal static let checkBoxM = IconImageSwiftGen(name: "check box(m)")
  internal static let checkBoxS = IconImageSwiftGen(name: "check box(s)")
  internal static let checkBoxSSelected = IconImageSwiftGen(name: "check box(s)_selected")
  internal static let check = IconImageSwiftGen(name: "check")
  internal static let close = IconImageSwiftGen(name: "close")
  internal static let dropBoxArrow1 = IconImageSwiftGen(name: "drop box_arrow-1")
  internal static let dropBoxArrow = IconImageSwiftGen(name: "drop box_arrow")
  internal static let edit = IconImageSwiftGen(name: "edit")
  internal static let flashOff = IconImageSwiftGen(name: "flash_off")
  internal static let flashOn = IconImageSwiftGen(name: "flash_on")
  internal static let gatherFill = IconImageSwiftGen(name: "gather_fill")
  internal static let gatherStroke = IconImageSwiftGen(name: "gather_stroke")
  internal static let giftVer1 = IconImageSwiftGen(name: "gift.ver1")
  internal static let homeFill = IconImageSwiftGen(name: "home_fill")
  internal static let homeStroke = IconImageSwiftGen(name: "home_stroke")
  internal static let likeFill = IconImageSwiftGen(name: "like_fill")
  internal static let likeStorke = IconImageSwiftGen(name: "like_storke")
  internal static let loginStar = IconImageSwiftGen(name: "login star")
  internal static let longArrowR1 = IconImageSwiftGen(name: "long arrow_r-1")
  internal static let longArrowR = IconImageSwiftGen(name: "long arrow_r")
  internal static let moreButton = IconImageSwiftGen(name: "more button")
  internal static let photoCard = IconImageSwiftGen(name: "photo card")
  internal static let photoClose = IconImageSwiftGen(name: "photo_close")
  internal static let search = IconImageSwiftGen(name: "search")
  internal static let shortArrowRM = IconImageSwiftGen(name: "short arrow_r(m)")
  internal static let shortArrowRS = IconImageSwiftGen(name: "short arrow_r(s)")
  internal static let system = IconImageSwiftGen(name: "system")
  internal static let topButton = IconImageSwiftGen(name: "top Button")
  internal static let wishVer1 = IconImageSwiftGen(name: "wish.ver1")
  internal static let writing = IconImageSwiftGen(name: "writing")
  internal static let writingHole = IconImageSwiftGen(name: "writing_ hole")
  internal static let zoom = IconImageSwiftGen(name: "zoom")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct IconImageSwiftGen {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
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

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension IconImageSwiftGen.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the IconImageSwiftGen.image property")
  convenience init?(asset: IconImageSwiftGen) {
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
