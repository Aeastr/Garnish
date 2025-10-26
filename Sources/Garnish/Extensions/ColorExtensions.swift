//
//  Color Extensions.swift
//  Garnish
//
//  Created by Aether on 15/12/2024.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
/// Type alias for the platform-specific color.
typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
/// Type alias for the platform-specific color.
typealias PlatformColor = NSColor
#endif


public extension Color {
    /// Returns HSB (Hue, Saturation, Brightness) components of the color
    var hsb: (hue: Double, saturation: Double, brightness: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (
            hue: Double(hue) * 360,  // Convert to degrees
            saturation: Double(saturation),
            brightness: Double(brightness)
        )
        #elseif os(macOS)
        let nsColor = NSColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        // Convert to RGB color space first if needed
        let rgbColor = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
        rgbColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (
            hue: Double(hue) * 360,  // Convert to degrees
            saturation: Double(saturation),
            brightness: Double(brightness)
        )
        #endif
    }

    /// Adjusts the brightness of a color using standardized RGB brightness calculation.
    /// Uses the same method as GarnishColor.adjustBrightness for consistency.
    ///
    /// - Parameter factor: Brightness adjustment factor (1.0 = no change, >1.0 = brighter, <1.0 = darker)
    /// - Returns: A new Color with adjusted brightness
    /// - Throws: `GarnishError.colorSpaceConversionFailed` if color cannot be converted to RGB color space
    func adjustedBrightness(by factor: CGFloat) throws -> Color {
        return try GarnishColor.adjustBrightness(of: self, by: factor)
    }

    /// Adjusts the luminance of a color using WCAG-compliant relative luminance calculation.
    /// Uses the same method as GarnishColor.adjustLuminance for consistency.
    ///
    /// - Parameter factor: Luminance adjustment factor (1.0 = no change, >1.0 = brighter, <1.0 = darker)
    /// - Returns: A new Color with adjusted luminance
    func adjustedLuminance(by factor: CGFloat) -> Color {
        return GarnishColor.adjustLuminance(of: self, by: factor)
    }

    /// Returns the hexadecimal string representation of the Color.
    ///
    /// - Parameter alpha: If `true` returns an 8-character hex including the alpha
    ///                    component, otherwise returns a 6-character hex string.
    /// - Returns: A hexadecimal string for the color.
    /// - Throws: `GarnishError.colorComponentExtractionFailed` if color components cannot be extracted
    func toHex(alpha: Bool = false) throws -> String {
        // Convert SwiftUI Color to a platform-specific color.
        let platformColor = PlatformColor(self)

        #if os(macOS)
        // For NSColor, ensure we're in RGB color space to avoid dynamic color issues
        guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(self, targetSpace: "deviceRGB")
        }

        let r = Float(rgbColor.redComponent)
        let g = Float(rgbColor.greenComponent)
        let b = Float(rgbColor.blueComponent)
        let a = Float(rgbColor.alphaComponent)

        #else
        // For UIColor, use getRed method
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard platformColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw GarnishError.colorComponentExtractionFailed(self)
        }

        let rFloat = Float(r)
        let gFloat = Float(g)
        let bFloat = Float(b)
        let aFloat = Float(a)
        #endif

        if alpha {
            #if os(macOS)
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255),
                          lroundf(a * 255))
            #else
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(rFloat * 255),
                          lroundf(gFloat * 255),
                          lroundf(bFloat * 255),
                          lroundf(aFloat * 255))
            #endif
        } else {
            #if os(macOS)
            return String(format: "%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255))
            #else
            return String(format: "%02lX%02lX%02lX",
                          lroundf(rFloat * 255),
                          lroundf(gFloat * 255),
                          lroundf(bFloat * 255))
            #endif
        }
    }
}
