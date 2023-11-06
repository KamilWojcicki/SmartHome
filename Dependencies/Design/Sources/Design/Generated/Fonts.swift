// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI
#if os(OSX)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
public typealias SystemFont = FontConvertible.SystemFont

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum FontFamily {
  public enum Poppins {
    public static let black = FontConvertible(name: "Poppins-Black", family: "Poppins", path: "Poppins-Black.ttf")
    public static let bold = FontConvertible(name: "Poppins-Bold", family: "Poppins", path: "Poppins-Bold.ttf")
    public static let italic = FontConvertible(name: "Poppins-Italic", family: "Poppins", path: "Poppins-Italic.ttf")
    public static let light = FontConvertible(name: "Poppins-Light", family: "Poppins", path: "Poppins-Light.ttf")
    public static let medium = FontConvertible(name: "Poppins-Medium", family: "Poppins", path: "Poppins-Medium.ttf")
    public static let regular = FontConvertible(name: "Poppins-Regular", family: "Poppins", path: "Poppins-Regular.ttf")
    public static let semiBold = FontConvertible(name: "Poppins-SemiBold", family: "Poppins", path: "Poppins-SemiBold.ttf")
    public static let thin = FontConvertible(name: "Poppins-Thin", family: "Poppins", path: "Poppins-Thin.ttf")
    public static let all: [FontConvertible] = [black, bold, italic, light, medium, regular, semiBold, thin]
  }
  public static let allCustomFonts: [FontConvertible] = [Poppins.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(OSX)
  public typealias SystemFont = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias SystemFont = UIFont
  #endif

  public func font(size: CGFloat) -> SystemFont {
    guard let font = SystemFont(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  public func textStyle(_ textStyle: Font.TextStyle) -> Font {
    Font.mappedFont(name, textStyle: textStyle)
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension FontConvertible.SystemFont {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
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

fileprivate extension Font {
  static func mappedFont(_ name: String, textStyle: TextStyle) -> Font {
    let fontSize = UIFont.preferredFont(forTextStyle: self.mapToUIFontTextStyle(textStyle)).pointSize
    return Font.custom(name, size: fontSize, relativeTo: textStyle)
  }

  // swiftlint:disable:next cyclomatic_complexity
  static func mapToUIFontTextStyle(_ textStyle: SwiftUI.Font.TextStyle) -> UIFont.TextStyle {
    switch textStyle {
    case .largeTitle:
      return .largeTitle
    case .title:
      return .title1
    case .title2:
      return .title2
    case .title3:
      return .title3
    case .headline:
      return .headline
    case .subheadline:
      return .subheadline
    case .callout:
      return .callout
    case .body:
      return .body
    case .caption:
      return .caption1
    case .caption2:
      return .caption2
    case .footnote:
      return .footnote
    @unknown default:
      fatalError("Missing a TextStyle mapping")
    }
  }
}

// swiftlint:enable convenience_type
