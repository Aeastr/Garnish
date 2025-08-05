import SwiftUI

/// Deprecated methods for the main Garnish class.
/// These methods are maintained for backward compatibility but should not be used in new code.
public extension Garnish {
    
    // MARK: - Legacy Utility Functions (Deprecated)
    
    /// **DEPRECATED**: Use `GarnishMath.classify(_:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.classify(_:) instead")
    static func isLightColor(_ color: Color, debug: Bool = false) -> Bool {
        let result = (try? GarnishMath.classify(color)) == .light
        if debug {
            let luminance = (try? GarnishMath.relativeLuminance(of: color)) ?? 0.0
            print("is light \(luminance)")
        }
        return result
    }
    
    /// **DEPRECATED**: Use `GarnishMath.classify(_:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.classify(_:) instead")
    static func isDarkColor(_ color: Color) -> Bool {
        return (try? GarnishMath.classify(color)) == .dark
    }
    
    /// **DEPRECATED**: Use `GarnishMath.colorScheme(for:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.colorScheme(for:) instead")
    static func determineColorScheme(_ color: Color) -> ColorScheme {
        // Maintain non-throwing behavior with fallback
        return (try? GarnishMath.colorScheme(for: color)) ?? .light
    }
    
    /// **DEPRECATED**: Use `GarnishMath.contrastRatio(between:and:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.contrastRatio(between:and:) instead")
    static func luminanceContrastRatio(between c1: Color, and c2: Color) -> CGFloat {
        // Maintain original non-throwing behavior with fallback
        return (try? GarnishMath.contrastRatio(between: c1, and: c2)) ?? 1.0
    }
    
    @available(*, deprecated, message: "Use GarnishMath.relativeLuminance(of:) instead – this legacy wrapper is non-throwing and returns 0 on error")
    static func relativeLuminance(of color: Color) -> CGFloat {
        #if canImport(UIKit)
        return (try? UIColor(color).relativeLuminance()) ?? 0
        #elseif os(macOS)
        return (try? NSColor(color).relativeLuminance()) ?? 0
        #endif
    }
    
    @available(*, deprecated, message: "Use GarnishMath.brightness(of: method:) instead – this legacy wrapper is non-throwing and returns 0 on error")
    static func brightness(of color: Color) -> CGFloat {
        return (try? GarnishMath.rgbBrightness(of: color)) ?? 0
    }
    
    // MARK: - Legacy Core Functions (Deprecated)
    
    /// **DEPRECATED**: Use `contrastingShade(of:)` instead.
    @available(*, deprecated, message: "Use contrastingShade(of:) instead")
    static func contrastingForeground(for background: Color) -> Color {
        return (try? contrastingShade(of: background)) ?? background
    }
    
    /// **DEPRECATED**: Use `contrastingColor(_:against:)` instead.
    @available(*, deprecated, message: "Use contrastingColor(_:against:) instead")
    static func adjustForBackground(for color: Color, with backgroundColor: Color) -> Color {
        return (try? contrastingColor(color, against: backgroundColor)) ?? color
    }
}
