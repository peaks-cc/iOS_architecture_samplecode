// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
internal typealias AssetType = ImageAsset

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let gitHub = ImageAsset(name: "GitHub")
  internal static let account = ImageAsset(name: "account")
  internal static let angleRight = ImageAsset(name: "angle-right")
  internal static let catalog = ImageAsset(name: "catalog")
  internal static let favoriteOff = ImageAsset(name: "favorite-off")
  internal static let favoriteOn = ImageAsset(name: "favorite-on")
  internal static let favorite = ImageAsset(name: "favorite")
  internal static let first = ImageAsset(name: "first")
  internal static let fork = ImageAsset(name: "fork")
  internal static let info = ImageAsset(name: "info")
  internal static let issue = ImageAsset(name: "issue")
  internal static let project006CoverMedium = ImageAsset(name: "project006_cover_medium")
  internal static let repo = ImageAsset(name: "repo")
  internal static let second = ImageAsset(name: "second")
  internal static let unicorn = ImageAsset(name: "unicorn")
  internal static let watch = ImageAsset(name: "watch")

  // swiftlint:disable trailing_comma
  internal static let allColors: [ColorAsset] = [
  ]
  internal static let allImages: [ImageAsset] = [
    gitHub,
    account,
    angleRight,
    catalog,
    favoriteOff,
    favoriteOn,
    favorite,
    first,
    fork,
    info,
    issue,
    project006CoverMedium,
    repo,
    second,
    unicorn,
    watch,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  internal static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

internal extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
