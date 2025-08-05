import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Mathematical utilities for color analysis and contrast calculations.
/// Provides standardized, WCAG-compliant methods for luminance and contrast calculations.
public class GarnishMath {
    
    // MARK: - Brightness Calculation Methods
    
    /// Method for calculating color brightness/luminance
    public enum BrightnessMethod {
        /// WCAG 2.1 relative luminance calculation (recommended)
        case luminance
        /// Simple RGB averaging: (r + g + b) / 3
        case rgb
    }
    
    // MARK: - WCAG Standards
    
    /// WCAG AA contrast ratio threshold (4.5:1)
    public static let wcagAAThreshold: CGFloat = 4.5
    
    /// WCAG AAA contrast ratio threshold (7:1)  
    public static let wcagAAAThreshold: CGFloat = 7.0
    
    /// Default contrast threshold used throughout Garnish
    public static let defaultThreshold: CGFloat = wcagAAThreshold
    
    // MARK: - Luminance Calculations
    
    /// Calculates the relative luminance of a color using WCAG 2.1 standards.
    /// This is the recommended method for accessibility-compliant color analysis.
    ///
    /// Example:
    /// ```swift
    /// let luminance = GarnishMath.relativeLuminance(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance
    public static func relativeLuminance(of color: Color) -> CGFloat {
        #if canImport(UIKit)
        return UIColor(color).relativeLuminance()
        #elseif os(macOS)
        return NSColor(color).relativeLuminance()
        #else
        return 0
        #endif
    }
    
    /// Calculates brightness using simple RGB averaging.
    /// Less accurate than relativeLuminance but faster for non-accessibility use cases.
    ///
    /// Example:
    /// ```swift
    /// let brightness = GarnishMath.brightness(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the brightness
    public static func brightness(of color: Color) -> CGFloat {
        #if canImport(UIKit)
        let platformColor = UIColor(color)
        #elseif os(macOS)
        let platformColor = NSColor(color)
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        platformColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r + g + b) / 3.0
    }
    
    /// Calculates brightness using the specified method.
    ///
    /// - Parameters:
    ///   - color: The input color to analyze
    ///   - method: The calculation method to use (default: .luminance)
    /// - Returns: A value between 0.0 and 1.0 representing the brightness
    public static func brightness(of color: Color, using method: BrightnessMethod = .luminance) -> CGFloat {
        switch method {
        case .luminance:
            return relativeLuminance(of: color)
        case .rgb:
            return brightness(of: color)
        }
    }
    
    // MARK: - Contrast Calculations
    
    /// Computes the contrast ratio between two colors using WCAG 2.1 standards.
    /// Contrast ratio is defined as (L1 + 0.05) / (L2 + 0.05), where L1 is the 
    /// lighter color's luminance and L2 is the darker color's luminance.
    ///
    /// Example:
    /// ```swift
    /// let ratio = GarnishMath.contrastRatio(between: .white, and: .black)
    /// // Returns ~21.0 (maximum possible contrast)
    /// ```
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: Contrast ratio (1.0 to 21.0, where higher is better contrast)
    public static func contrastRatio(between color1: Color, and color2: Color) -> CGFloat {
        let l1 = relativeLuminance(of: color1)
        let l2 = relativeLuminance(of: color2)
        let maxLum = max(l1, l2)
        let minLum = min(l1, l2)
        return (maxLum + 0.05) / (minLum + 0.05)
    }
    
    /// Computes contrast ratio using the specified brightness method.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    ///   - method: The brightness calculation method to use
    /// - Returns: Contrast ratio based on the specified method
    public static func contrastRatio(between color1: Color, and color2: Color, using method: BrightnessMethod) -> CGFloat {
        let l1 = brightness(of: color1, using: method)
        let l2 = brightness(of: color2, using: method)
        let maxLum = max(l1, l2)
        let minLum = min(l1, l2)
        return (maxLum + 0.05) / (minLum + 0.05)
    }
    
    // MARK: - Color Classification
    
    /// Classification of a color as light or dark
    public enum ColorClassification {
        case light
        case dark
        
        /// Returns the corresponding SwiftUI ColorScheme
        public var colorScheme: ColorScheme {
            switch self {
            case .light: return .light
            case .dark: return .dark
            }
        }
    }
    
    /// Classifies a color as light or dark based on its brightness.
    ///
    /// - Parameters:
    ///   - color: The color to classify
    ///   - threshold: The brightness threshold (default: 0.5)
    ///   - method: The brightness calculation method to use
    /// - Returns: ColorClassification (.light or .dark)
    public static func classify(_ color: Color, threshold: CGFloat = 0.5, using method: BrightnessMethod = .luminance) -> ColorClassification {
        return brightness(of: color, using: method) > threshold ? .light : .dark
    }
    
    /// Convenience function: Determines the optimal ColorScheme for a given color.
    /// Equivalent to: `classify(color, using: method).colorScheme`
    ///
    /// - Parameters:
    ///   - color: The color to analyze
    ///   - method: The brightness calculation method to use
    /// - Returns: .light or .dark ColorScheme
    public static func colorScheme(for color: Color, using method: BrightnessMethod = .luminance) -> ColorScheme {
        return classify(color, using: method).colorScheme
    }
    
    // MARK: - Contrast Validation
    
    /// Convenience function: Checks if two colors meet WCAG AA contrast requirements.
    /// Equivalent to: `contrastRatio(between: color1, and: color2) >= wcagAAThreshold`
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 4.5:1
    public static func meetsWCAGAA(_ color1: Color, _ color2: Color) -> Bool {
        return contrastRatio(between: color1, and: color2) >= wcagAAThreshold
    }
    
    /// Checks if two colors meet WCAG AAA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 7:1
    public static func meetsWCAGAAA(_ color1: Color, _ color2: Color) -> Bool {
        return contrastRatio(between: color1, and: color2) >= wcagAAAThreshold
    }
}
