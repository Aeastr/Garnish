import SwiftUI

/// Deprecated methods for the GarnishMath class.
/// These methods are maintained for backward compatibility but should not be used in new code.
public extension GarnishMath {
    
    // MARK: - Legacy Color Classification (Deprecated)
    
    /// **DEPRECATED**: Use `classify(_:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.classify(_:) instead")
    static func isLightColor(_ color: Color, threshold: CGFloat = 0.5, using method: BrightnessMethod = .luminance) -> Bool {
        return (try? classify(color, threshold: threshold, using: method)) == .light
    }
    
    /// **DEPRECATED**: Use `classify(_:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.classify(_:) instead")
    static func isDarkColor(_ color: Color, threshold: CGFloat = 0.5, using method: BrightnessMethod = .luminance) -> Bool {
        return (try? classify(color, threshold: threshold, using: method)) == .dark
    }
    
    /// **DEPRECATED**: Use `colorScheme(for:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.colorScheme(for:) instead")
    static func determineColorScheme(for color: Color, using method: BrightnessMethod = .luminance) -> ColorScheme {
        return (try? colorScheme(for: color, using: method)) ?? .light
    }
    
    // MARK: - Legacy Contrast Functions (Deprecated)
    
    /// **DEPRECATED**: Use `contrastRatio(between:and:)` instead.
    @available(*, deprecated, message: "Use GarnishMath.contrastRatio(between:and:) instead")
    static func luminanceContrastRatio(between color1: Color, and color2: Color) -> CGFloat {
        return (try? contrastRatio(between: color1, and: color2)) ?? 1.0
    }
}
