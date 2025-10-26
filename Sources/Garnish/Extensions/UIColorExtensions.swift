//
//  UI Color Extensions.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

internal extension UIColor {
    /// Blends the current color with another color by a given ratio.
    ///
    /// - Ratio of `0.0` results in 100% of the original color.
    /// - Ratio of `1.0` results in 100% of the blended color.
    ///
    /// Example:
    /// ```swift
    /// let blendedColor = UIColor.red.blend(with: .blue, ratio: 0.5)
    /// ```
    ///
    /// - Parameters:
    ///   - other: The color to blend with.
    ///   - ratio: The blend ratio (0.0 to 1.0).
    /// - Returns: A new `UIColor` object that is the result of the blend.
    func blend(with other: UIColor, ratio: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = r1 * (1 - ratio) + r2 * ratio
        let g = g1 * (1 - ratio) + g2 * ratio
        let b = b1 * (1 - ratio) + b2 * ratio
        let a = a1 * (1 - ratio) + a2 * ratio

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// Calculates the relative luminance of the current color.
    ///
    /// Example:
    /// ```swift
    /// let luminance = try UIColor.red.relativeLuminance()
    /// ```
    ///
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance.
    /// - Throws: `GarnishError.colorComponentExtractionFailed` if color components cannot be extracted
    func relativeLuminance() throws -> CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw GarnishError.colorComponentExtractionFailed(Color(self))
        }

        func lum(_ v: CGFloat) -> CGFloat {
            // Apply sRGB companding.
            return (v <= 0.03928) ? (v / 12.92) : pow((v + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * lum(r) + 0.7152 * lum(g) + 0.0722 * lum(b)
    }
}

#elseif os(macOS)
import AppKit

internal extension NSColor {
    /// Blends the current color with another color by a given ratio.
    ///
    /// - Ratio of `0.0` results in 100% of the original color.
    /// - Ratio of `1.0` results in 100% of the blended color.
    ///
    /// Example:
    /// ```swift
    /// let blendedColor = NSColor.red.blend(with: .blue, ratio: 0.5)
    /// ```
    ///
    /// - Parameters:
    ///   - other: The color to blend with.
    ///   - ratio: The blend ratio (0.0 to 1.0).
    /// - Returns: A new `NSColor` object that is the result of the blend.
    func blend(with other: NSColor, ratio: CGFloat) -> NSColor {
        // Ensure both colors are in the device RGB color space.
        guard let color1 = usingColorSpace(.deviceRGB),
              let color2 = other.usingColorSpace(.deviceRGB) else {
            return self
        }

        let r1 = color1.redComponent
        let g1 = color1.greenComponent
        let b1 = color1.blueComponent
        let a1 = color1.alphaComponent

        let r2 = color2.redComponent
        let g2 = color2.greenComponent
        let b2 = color2.blueComponent
        let a2 = color2.alphaComponent

        let r = r1 * (1 - ratio) + r2 * ratio
        let g = g1 * (1 - ratio) + g2 * ratio
        let b = b1 * (1 - ratio) + b2 * ratio
        let a = a1 * (1 - ratio) + a2 * ratio

        return NSColor(calibratedRed: r, green: g, blue: b, alpha: a)
    }

    /// Calculates the relative luminance of the current color.
    ///
    /// Example:
    /// ```swift
    /// let luminance = try NSColor.red.relativeLuminance()
    /// ```
    ///
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance.
    /// - Throws: `GarnishError.colorSpaceConversionFailed` if color cannot be converted to RGB color space
    func relativeLuminance() throws -> CGFloat {
        // Ensure the color is in the device RGB color space.
        guard let color = usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(Color(self), targetSpace: "deviceRGB")
        }

        let r = color.redComponent
        let g = color.greenComponent
        let b = color.blueComponent

        func lum(_ v: CGFloat) -> CGFloat {
            return (v <= 0.03928) ? (v / 12.92) : pow((v + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * lum(r) + 0.7152 * lum(g) + 0.0722 * lum(b)
    }
}
#endif
