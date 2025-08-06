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
    
    /// Generates a contrasting shade of the same color that meets WCAG standards.
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
    ///   - targetRatio: Minimum contrast ratio to achieve (default: WCAG AA = 4.5)
    /// - Returns: A contrasting shade of the input color that meets the target contrast ratio
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold
    ) throws -> Color {
        // contrastingShade is just contrastingColor against itself
        return try contrastingColor(color, against: color, using: method, targetRatio: targetRatio)
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
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold
    ) throws -> Color {
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
        
        // Try both black and white to see which gives better contrast against the background
        let blackBase: PlatformColor = .black
        let whiteBase: PlatformColor = .white
        
        // Test a moderate blend with both bases to see which direction works better
        let testBlendAmount: CGFloat = 0.5
        let blackTest = platformColor.blend(with: blackBase, ratio: testBlendAmount)
        let whiteTest = platformColor.blend(with: whiteBase, ratio: testBlendAmount)
        
        let blackRatio = try GarnishMath.contrastRatio(between: Color(blackTest), and: background)
        let whiteRatio = try GarnishMath.contrastRatio(between: Color(whiteTest), and: background)
        
        // Choose the direction that gives better contrast
        let contrastingBase = blackRatio > whiteRatio ? blackBase : whiteBase
        
        // Binary search for the right blend amount to achieve target contrast
        var lowBlend: CGFloat = 0.0
        var highBlend: CGFloat = 1.0
        var bestBlend: CGFloat = 0.0
        var bestRatio: CGFloat = 0.0
        let maxIterations = 5
        
        for _ in 0..<maxIterations {
            let testBlend = (lowBlend + highBlend) / 2.0
            let testColor = platformColor.blend(with: contrastingBase, ratio: testBlend)
            let testRatio = try GarnishMath.contrastRatio(between: Color(testColor), and: background)
            
            // Always update best if this is better than previous best
            if testRatio >= targetRatio && (bestRatio < targetRatio || testBlend < bestBlend) {
                bestBlend = testBlend
                bestRatio = testRatio
            }
            
            if testRatio >= targetRatio {
                // We have enough contrast, try with less blending
                highBlend = testBlend
            } else {
                // Not enough contrast, need more blending
                lowBlend = testBlend
                // If we don't have a valid solution yet, this is our current best
                if bestRatio < targetRatio {
                    bestBlend = testBlend
                    bestRatio = testRatio
                }
            }
            
            // If we're close enough to target, break early
            if bestRatio >= targetRatio && abs(bestRatio - targetRatio) < 0.1 {
                break
            }
        }
        
        let result = platformColor.blend(with: contrastingBase, ratio: bestBlend)
        return Color(result)
    }
    
    /// Quick accessibility check.
    /// - Throws: `GarnishError` if color analysis fails
    public static func hasGoodContrast(_ color1: Color, _ color2: Color) throws -> Bool {
        return try GarnishMath.meetsWCAGAA(color1, color2)
    }
}



// Preview removed - demo views were moved to new GarnishDemo.swift
