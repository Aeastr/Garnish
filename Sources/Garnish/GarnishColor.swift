import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Color manipulation utilities for advanced color operations.
/// Provides blending, brightness adjustment, and other color transformation functions.
public class GarnishColor {
    
    // MARK: - Color Blending
    
    /// Blends two colors together using a specified ratio.
    ///
    /// - Parameters:
    ///   - color1: The base color
    ///   - color2: The color to blend with
    ///   - ratio: Blend ratio (0.0 = 100% color1, 1.0 = 100% color2)
    /// - Returns: The blended color
    public static func blend(_ color1: Color, with color2: Color, ratio: CGFloat) -> Color {
        #if canImport(UIKit)
        let platformColor1 = UIColor(color1)
        let platformColor2 = UIColor(color2)
        let result = platformColor1.blend(with: platformColor2, ratio: ratio)
        return Color(result)
        #elseif os(macOS)
        let platformColor1 = NSColor(color1)
        let platformColor2 = NSColor(color2)
        let result = platformColor1.blend(with: platformColor2, ratio: ratio)
        return Color(result)
        #endif
    }
    
    // MARK: - Brightness Adjustment
    
    /// Adjusts the brightness of a color by a percentage.
    ///
    /// - Parameters:
    ///   - color: The color to adjust
    ///   - percentage: Adjustment percentage (-1.0 to 1.0, where positive lightens, negative darkens)
    /// - Returns: Color with adjusted brightness
    /// - Throws: `GarnishError.colorSpaceConversionFailed` if color cannot be converted to RGB color space
    public static func adjustBrightness(of color: Color, by percentage: CGFloat) throws -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        #if canImport(UIKit)
        platformColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #elseif os(macOS)
        // For NSColor, ensure we're in RGB color space to avoid dynamic color issues
        guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(color, targetSpace: "deviceRGB")
        }
        r = rgbColor.redComponent
        g = rgbColor.greenComponent
        b = rgbColor.blueComponent
        a = rgbColor.alphaComponent
        #endif
        
        let factor = 1.0 + percentage
        let newR = min(max(r * factor, 0), 1)
        let newG = min(max(g * factor, 0), 1)
        let newB = min(max(b * factor, 0), 1)
        
        #if canImport(UIKit)
        return Color(PlatformColor(red: newR, green: newG, blue: newB, alpha: a))
        #elseif os(macOS)
        return Color(PlatformColor(calibratedRed: newR, green: newG, blue: newB, alpha: a))
        #endif
    }
    
    /// Adjusts the luminance (HSB brightness) of a color by a factor.
    ///
    /// - Parameters:
    ///   - color: The color to adjust
    ///   - factor: Luminance factor (1.0 = no change, >1.0 = brighter, <1.0 = darker)
    /// - Returns: Color with adjusted luminance
    public static func adjustLuminance(of color: Color, by factor: CGFloat) -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        #if canImport(UIKit)
        platformColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let newBrightness = max(min(b * factor, 1.0), 0.0)
        return Color(PlatformColor(hue: h, saturation: s, brightness: newBrightness, alpha: a))
        #elseif os(macOS)
        let rgbColor = platformColor.usingColorSpace(.deviceRGB) ?? platformColor
        rgbColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let newBrightness = max(min(b * factor, 1.0), 0.0)
        return Color(PlatformColor(calibratedHue: h, saturation: s, brightness: newBrightness, alpha: a))
        #endif
    }
    
    // MARK: - Color Conversion
    
    /// Converts a color to its hexadecimal string representation.
    ///
    /// - Parameters:
    ///   - color: The color to convert
    ///   - includeAlpha: Whether to include alpha channel (default: false)
    /// - Returns: Hexadecimal string (e.g., "FF0000" for red)
    /// - Throws: `GarnishError.colorComponentExtractionFailed` or `GarnishError.colorSpaceConversionFailed` if color processing fails
    public static func toHex(_ color: Color, includeAlpha: Bool = false) throws -> String {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        
        #if canImport(UIKit)
        guard let components = platformColor.cgColor.components else {
            throw GarnishError.colorComponentExtractionFailed(color)
        }
        
        guard components.count >= 3 else {
            throw GarnishError.colorComponentExtractionFailed(color)
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = components.count >= 4 ? Float(components[3]) : 1.0
        
        #elseif os(macOS)
        // For NSColor, ensure we're in RGB color space to avoid dynamic color issues
        guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(color, targetSpace: "deviceRGB")
        }
        
        let r = Float(rgbColor.redComponent)
        let g = Float(rgbColor.greenComponent)
        let b = Float(rgbColor.blueComponent)
        let a = Float(rgbColor.alphaComponent)
        #endif
        
        if includeAlpha {
            return String(format: "%02lX%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255),
                         lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255))
        }
    }
    
    /// Creates a color from a hexadecimal string.
    ///
    /// - Parameter hex: Hexadecimal string (with or without #, supports 3, 6, or 8 characters)
    /// - Returns: Color created from hex string, or nil if invalid
    public static func fromHex(_ hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        let r, g, b, a: CGFloat
        
        switch length {
        case 3: // RGB
            r = CGFloat((rgb & 0xF00) >> 8) / 15.0
            g = CGFloat((rgb & 0x0F0) >> 4) / 15.0
            b = CGFloat(rgb & 0x00F) / 15.0
            a = 1.0
        case 6: // RRGGBB
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        default:
            return nil
        }
        
        return Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
