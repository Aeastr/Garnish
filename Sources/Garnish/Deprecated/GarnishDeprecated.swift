import SwiftUI

/// Deprecated methods for the main Garnish class.
/// These methods are maintained for backward compatibility but should not be used in new code.
public extension Garnish {
    
    // MARK: - Legacy Utility Functions (Deprecated)
    
    /// **DEPRECATED**: Use `classify(_:)` instead.
    @available(*, deprecated, message: "Use Garnish.classify(_:) instead")
    static func isLightColor(_ color: Color, debug: Bool = false) -> Bool {
        let result = GarnishMath.classify(color) == .light
        if debug {
            print("is light \(GarnishMath.relativeLuminance(of: color))")
        }
        return result
    }
    
    /// **DEPRECATED**: Use `classify(_:)` instead.
    @available(*, deprecated, message: "Use Garnish.classify(_:) instead")
    static func isDarkColor(_ color: Color) -> Bool {
        return GarnishMath.classify(color) == .dark
    }
    
    /// **DEPRECATED**: Use `colorScheme(for:)` instead.
    @available(*, deprecated, message: "Use Garnish.colorScheme(for:) instead")
    static func determineColorScheme(_ color: Color) -> ColorScheme {
        return GarnishMath.colorScheme(for: color)
    }
    
    /// **DEPRECATED**: Use `contrastRatio(between:and:)` instead.
    @available(*, deprecated, message: "Use Garnish.contrastRatio(between:and:) instead")
    static func luminanceContrastRatio(between c1: Color, and c2: Color) -> CGFloat {
        return GarnishMath.contrastRatio(between: c1, and: c2)
    }
    
    // MARK: - Legacy Core Functions (Deprecated)
    
    /// **DEPRECATED**: Use `contrastingShade(of:)` instead.
    @available(*, deprecated, message: "Use contrastingShade(of:) instead")
    static func contrastingForeground(for background: Color) -> Color {
        return contrastingShade(of: background)
    }
    
    /// **DEPRECATED**: Use `contrastingColor(_:against:)` instead.
    @available(*, deprecated, message: "Use contrastingColor(_:against:) instead")
    static func adjustForBackground(for color: Color, with backgroundColor: Color) -> Color {
        return contrastingColor(color, against: backgroundColor)
    }
}
