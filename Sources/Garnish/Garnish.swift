// Garnish - Clean Color Contrast Utilities
// Refactored for simplicity, consistency, and WCAG compliance

import SwiftUI

/// **Garnish** - Clean, simple color contrast utilities.
/// 
/// Provides two main functions:
/// 1. **Monochromatic contrast**: Find a good shade of the same color
/// 2. **Bi-chromatic contrast**: Optimize one color against another
///
/// All calculations use WCAG-compliant standards for accessibility.
public class Garnish {
    
    // MARK: - Core API (New)
    
    /// Generates a contrasting shade of the same color.
    /// **Use Case 1**: "I have blue, give me a shade of blue that looks good against blue"
    ///
    /// Example:
    /// ```swift
    /// let contrastingBlue = Garnish.contrastingShade(of: .blue)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The base color to create a contrasting shade from
    ///   - method: Brightness calculation method (default: .luminance)
    ///   - blendAmount: How much to blend toward contrasting base (default: 0.8)
    /// - Returns: A contrasting shade of the input color
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        blendAmount: CGFloat = 0.8
    ) -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        let isLight = GarnishMath.classify(color, using: method) == .light
        
        // Choose contrasting base: black for light colors, white for dark colors
        let contrastingBase: PlatformColor = isLight ? .black : .white
        
        // Blend the original color with the contrasting base
        let result = platformColor.blend(with: contrastingBase, ratio: blendAmount)
        return Color(result)
    }
    
    /// Optimizes one color to work well against another background.
    /// **Use Case 2**: "I have blue and red, which version of red looks best against blue?"
    ///
    /// Example:
    /// ```swift
    /// let optimizedRed = Garnish.contrastingColor(.red, against: .blue)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The color to optimize
    ///   - background: The background color to optimize against
    ///   - method: Brightness calculation method (default: .luminance)
    ///   - targetRatio: Minimum contrast ratio (default: WCAG AA = 4.5)
    /// - Returns: Optimized version of the input color
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold
    ) -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        let currentRatio = try GarnishMath.contrastRatio(between: color, and: background)
        
        // If contrast is already sufficient, return original color
        if currentRatio >= targetRatio {
            return color
        }
        
        // Determine which direction to adjust (toward black or white)
        let backgroundIsLight = GarnishMath.classify(background, using: method) == .light
        let contrastingBase: PlatformColor = backgroundIsLight ? .black : .white
        
        // Binary search for the right blend amount to achieve target contrast
        var lowBlend: CGFloat = 0.0
        var highBlend: CGFloat = 1.0
        var bestBlend: CGFloat = 0.5
        let maxIterations = 10
        
        for _ in 0..<maxIterations {
            let testBlend = (lowBlend + highBlend) / 2.0
            let testColor = platformColor.blend(with: contrastingBase, ratio: testBlend)
            let testRatio = try GarnishMath.contrastRatio(between: Color(testColor), and: background)
            
            if testRatio >= targetRatio {
                bestBlend = testBlend
                highBlend = testBlend
            } else {
                lowBlend = testBlend
            }
            
            // If we're close enough, break early
            if abs(testRatio - targetRatio) < 0.1 {
                break
            }
        }
        
        let result = platformColor.blend(with: contrastingBase, ratio: bestBlend)
        return Color(result)
    }
    
    /// Quick accessibility check.
    public static func hasGoodContrast(_ color1: Color, _ color2: Color) -> Bool {
        return GarnishMath.meetsWCAGAA(color1, color2)
    }
}



// Preview removed - demo views were moved to new GarnishDemo.swift
