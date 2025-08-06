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
    /// let luminance = try GarnishMath.relativeLuminance(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance
    /// - Throws: `GarnishError.colorComponentExtractionFailed` or `GarnishError.colorSpaceConversionFailed`
    public static func relativeLuminance(of color: Color) throws -> CGFloat {
        #if canImport(UIKit)
        return try UIColor(color).relativeLuminance()
        #elseif os(macOS)
        return try NSColor(color).relativeLuminance()
        #else
        throw GarnishError.colorComponentExtractionFailed(color)
        #endif
    }
    
    /// Calculates brightness using simple RGB averaging.
    /// Less accurate than relativeLuminance but faster for non-accessibility use cases.
    ///
    /// Example:
    /// ```swift
    /// let brightness = try GarnishMath.rgbBrightness(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the brightness
    /// - Throws: `GarnishError.colorComponentExtractionFailed` if color components cannot be extracted
    public static func rgbBrightness(of color: Color) throws -> CGFloat {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw GarnishError.colorComponentExtractionFailed(color)
        }
        return (r + g + b) / 3.0
        #elseif os(macOS)
        let nsColor = NSColor(color)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(color, targetSpace: "deviceRGB")
        }
        return (rgbColor.redComponent + rgbColor.greenComponent + rgbColor.blueComponent) / 3.0
        #else
        throw GarnishError.colorComponentExtractionFailed(color)
        #endif
    }
    
    /// Calculates brightness using the specified method.
    ///
    /// - Parameters:
    ///   - color: The color to analyze
    ///   - method: The calculation method to use
    /// - Returns: A value between 0.0 and 1.0 representing brightness
    /// - Throws: `GarnishError` if color component extraction fails
    public static func brightness(of color: Color, using method: BrightnessMethod = .luminance) throws -> CGFloat {
        switch method {
        case .luminance:
            return try relativeLuminance(of: color)
        case .rgb:
            return try rgbBrightness(of: color)
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
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastRatio(between color1: Color, and color2: Color) throws -> CGFloat {
        let l1 = try relativeLuminance(of: color1)
        let l2 = try relativeLuminance(of: color2)
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
    /// - Throws: `GarnishError` if color analysis fails
    public static func classify(_ color: Color, threshold: CGFloat = 0.5, using method: BrightnessMethod = .luminance) throws -> ColorClassification {
        return try brightness(of: color, using: method) > threshold ? .light : .dark
    }
    
    /// Convenience function: Determines the optimal ColorScheme for a given color.
    ///
    /// - Parameters:
    ///   - color: The color to analyze
    ///   - method: The brightness calculation method to use
    /// - Returns: .light or .dark ColorScheme
    /// - Throws: `GarnishError` if color analysis fails
    public static func colorScheme(for color: Color, using method: BrightnessMethod = .luminance) throws -> ColorScheme {
        return try classify(color, using: method).colorScheme
    }
    
    // MARK: - Contrast Validation
    
    /// Checks if two colors meet WCAG AA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 4.5:1
    /// - Throws: `GarnishError` if color analysis fails
    public static func meetsWCAGAA(_ color1: Color, _ color2: Color) throws -> Bool {
        return try contrastRatio(between: color1, and: color2) >= wcagAAThreshold
    }
    
    /// Checks if contrast ratio meets WCAG AA contrast requirements.
    ///
    /// - Parameters:
    ///   - ratio: Contrast Ratio
    /// - Returns: True if contrast ratio >= 4.5:1
    public static func meetsWCAGAA(_ ratio: CGFloat) -> Bool {
        return ratio >= wcagAAThreshold
    }
    
    /// Checks if two colors meet WCAG AAA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 7:1
    /// - Throws: `GarnishError` if color analysis fails
    public static func meetsWCAGAAA(_ color1: Color, _ color2: Color) throws -> Bool {
        return try contrastRatio(between: color1, and: color2) >= wcagAAAThreshold
    }
    
    /// Checks if contrast ratio meets WCAG AAA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 7:1
    /// - Throws: `GarnishError` if color analysis fails
    public static func meetsWCAGAAA(_ ratio: CGFloat) -> Bool {
        return ratio >= wcagAAAThreshold
    }
    
    // MARK: - Color Harmony
    
    /// LCH (Lightness, Chroma, Hue) color representation for advanced color operations
    public struct LCHColor {
        /// Lightness (0-100)
        public let lightness: CGFloat
        /// Chroma (saturation intensity, 0-100+)
        public let chroma: CGFloat
        /// Hue angle in degrees (0-360)
        public let hue: CGFloat
        
        public init(lightness: CGFloat, chroma: CGFloat, hue: CGFloat) {
            self.lightness = lightness
            self.chroma = chroma
            self.hue = hue
        }
    }
    
    /// Converts RGB to LCH color space
    /// - Parameter color: SwiftUI Color to convert
    /// - Returns: LCH representation
    /// - Throws: `GarnishError` if color conversion fails
    public static func rgbToLCH(_ color: Color) throws -> LCHColor {
        #if canImport(UIKit)
        let platformColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard platformColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw GarnishError.colorComponentExtractionFailed(color)
        }
        #elseif os(macOS)
        let platformColor = NSColor(color)
        guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
            throw GarnishError.colorSpaceConversionFailed(color, targetSpace: "deviceRGB")
        }
        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent  
        let b = rgbColor.blueComponent
        #endif
        
        // Convert sRGB to XYZ
        let rLinear = r > 0.04045 ? pow((r + 0.055) / 1.055, 2.4) : r / 12.92
        let gLinear = g > 0.04045 ? pow((g + 0.055) / 1.055, 2.4) : g / 12.92
        let bLinear = b > 0.04045 ? pow((b + 0.055) / 1.055, 2.4) : b / 12.92
        
        let x = rLinear * 0.4124564 + gLinear * 0.3575761 + bLinear * 0.1804375
        let y = rLinear * 0.2126729 + gLinear * 0.7151522 + bLinear * 0.0721750
        let z = rLinear * 0.0193339 + gLinear * 0.1191920 + bLinear * 0.9503041
        
        // Convert XYZ to LAB
        let xn: CGFloat = 0.95047  // D65 illuminant
        let yn: CGFloat = 1.00000
        let zn: CGFloat = 1.08883
        
        let fx = (x / xn) > 0.008856 ? pow(x / xn, 1.0/3.0) : (7.787 * (x / xn) + 16.0/116.0)
        let fy = (y / yn) > 0.008856 ? pow(y / yn, 1.0/3.0) : (7.787 * (y / yn) + 16.0/116.0)
        let fz = (z / zn) > 0.008856 ? pow(z / zn, 1.0/3.0) : (7.787 * (z / zn) + 16.0/116.0)
        
        let lStar = 116.0 * fy - 16.0
        let aStar = 500.0 * (fx - fy)
        let bStar = 200.0 * (fy - fz)
        
        // Convert LAB to LCH
        let lightness = lStar
        let chroma = sqrt(aStar * aStar + bStar * bStar)
        var hue = atan2(bStar, aStar) * 180.0 / .pi
        if hue < 0 {
            hue += 360.0
        }
        
        return LCHColor(lightness: lightness, chroma: chroma, hue: hue)
    }
    
    /// Converts LCH to RGB color
    /// - Parameter lch: LCH color to convert
    /// - Returns: SwiftUI Color
    public static func lchToRGB(_ lch: LCHColor) -> Color {
        // Convert LCH to LAB
        let lStar = lch.lightness
        let aStar = lch.chroma * cos(lch.hue * .pi / 180.0)
        let bStar = lch.chroma * sin(lch.hue * .pi / 180.0)
        
        // Convert LAB to XYZ
        let fy = (lStar + 16.0) / 116.0
        let fx = aStar / 500.0 + fy
        let fz = fy - bStar / 200.0
        
        let xn: CGFloat = 0.95047  // D65 illuminant
        let yn: CGFloat = 1.00000
        let zn: CGFloat = 1.08883
        
        let x = xn * (fx > 0.206897 ? pow(fx, 3.0) : (fx - 16.0/116.0) / 7.787)
        let y = yn * (fy > 0.206897 ? pow(fy, 3.0) : (fy - 16.0/116.0) / 7.787)
        let z = zn * (fz > 0.206897 ? pow(fz, 3.0) : (fz - 16.0/116.0) / 7.787)
        
        // Convert XYZ to sRGB
        let rLinear = x * 3.2404542 + y * -1.5371385 + z * -0.4985314
        let gLinear = x * -0.9692660 + y * 1.8760108 + z * 0.0415560
        let bLinear = x * 0.0556434 + y * -0.2040259 + z * 1.0572252
        
        let r = rLinear > 0.0031308 ? 1.055 * pow(rLinear, 1.0/2.4) - 0.055 : 12.92 * rLinear
        let g = gLinear > 0.0031308 ? 1.055 * pow(gLinear, 1.0/2.4) - 0.055 : 12.92 * gLinear
        let b = bLinear > 0.0031308 ? 1.055 * pow(bLinear, 1.0/2.4) - 0.055 : 12.92 * bLinear
        
        return Color(.sRGB, 
                     red: max(0, min(1, r)), 
                     green: max(0, min(1, g)), 
                     blue: max(0, min(1, b)))
    }
    
    /// Calculates color harmony score between two colors using LCH color space
    /// Higher scores indicate better harmony
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color (reference color)
    ///   - hueWeight: Importance of hue harmony (default: 0.5)
    ///   - temperatureWeight: Importance of temperature harmony (default: 0.3)
    ///   - chromaWeight: Importance of chroma harmony (default: 0.2)
    /// - Returns: Harmony score (0.0 to 1.0, higher is better)
    /// - Throws: `GarnishError` if color conversion fails
    public static func harmonyScore(
        between color1: Color, 
        and color2: Color,
        hueWeight: CGFloat = 0.5,
        temperatureWeight: CGFloat = 0.3, 
        chromaWeight: CGFloat = 0.2
    ) throws -> CGFloat {
        let lch1 = try rgbToLCH(color1)
        let lch2 = try rgbToLCH(color2)
        
        // Hue harmony: favor complementary (180°), triadic (120°), or analogous (<30°) relationships
        let hueDiff = abs(lch1.hue - lch2.hue)
        let normalizedHueDiff = min(hueDiff, 360 - hueDiff) // Handle wraparound
        
        let hueScore: CGFloat
        if normalizedHueDiff < 30 {
            // Analogous colors
            hueScore = 1.0 - (normalizedHueDiff / 30.0) * 0.3
        } else if abs(normalizedHueDiff - 180) < 30 {
            // Complementary colors
            hueScore = 1.0 - (abs(normalizedHueDiff - 180) / 30.0) * 0.2
        } else if abs(normalizedHueDiff - 120) < 30 || abs(normalizedHueDiff - 240) < 30 {
            // Triadic colors
            let triadicDiff = min(abs(normalizedHueDiff - 120), abs(normalizedHueDiff - 240))
            hueScore = 0.8 - (triadicDiff / 30.0) * 0.2
        } else {
            // Less harmonious relationships
            hueScore = 0.4
        }
        
        // Temperature harmony: determine warm vs cool and penalize mismatches
        let color1Temp = getTemperature(hue: lch1.hue)
        let color2Temp = getTemperature(hue: lch2.hue)
        let temperatureScore = color1Temp == color2Temp ? 1.0 : 0.6
        
        // Chroma harmony: similar saturation levels work better together
        let chromaDiff = abs(lch1.chroma - lch2.chroma)
        let maxChroma = max(lch1.chroma, lch2.chroma)
        let chromaScore = maxChroma > 0 ? 1.0 - (chromaDiff / maxChroma) * 0.5 : 1.0
        
        // Weighted combination
        let totalScore = (hueScore * hueWeight + 
                         temperatureScore * temperatureWeight + 
                         chromaScore * chromaWeight)
        
        return min(max(totalScore, 0.0), 1.0)
    }
    
    /// Determines if a hue is warm or cool
    /// - Parameter hue: Hue angle in degrees (0-360)
    /// - Returns: Temperature classification
    private static func getTemperature(hue: CGFloat) -> ColorTemperature {
        // Warm: red, orange, yellow (~315-45°)
        // Cool: blue, green, purple (~135-285°)
        if hue >= 315 || hue <= 45 {
            return .warm
        } else if hue >= 135 && hue <= 285 {
            return .cool
        } else {
            // Transition zones lean toward dominant adjacent temperature
            return hue < 135 ? .warm : .cool
        }
    }
    
    /// Color temperature classification
    private enum ColorTemperature {
        case warm
        case cool
    }
}
