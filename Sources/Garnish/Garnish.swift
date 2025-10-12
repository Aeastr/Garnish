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

    /// Direction to bias the contrasting color generation
    public enum ContrastDirection {
        /// Automatically choose between light and dark based on which provides better contrast
        case auto
        /// Force towards white/lighter shades (useful for highlights)
        case forceLight
        /// Force towards black/darker shades (useful for shadows)
        case forceDark
        /// Prefer lighter shades, but switch to dark if necessary to meet target contrast
        case preferLight
        /// Prefer darker shades, but switch to light if necessary to meet target contrast
        case preferDark
    }

    // MARK: - Core API (New)
    
    /// Generates a contrasting shade of the same color that meets WCAG standards.
    /// **Use Case 1**: "I have blue, give me a shade of blue that looks good against blue"
    ///
    /// Example:
    /// ```swift
    /// let contrastingBlue = Garnish.contrastingShade(of: .blue)
    /// let shadowBlue = Garnish.contrastingShade(of: .blue, direction: .forceDark)
    /// let preferWhite = Garnish.contrastingShade(of: .blue, direction: .preferLight)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The base color to create a contrasting shade from
    ///   - method: Brightness calculation method (default: .luminance)
    ///   - targetRatio: Minimum contrast ratio to achieve (default: WCAG AA = 4.5)
    ///   - direction: Direction preference (default: .auto)
    ///     - `.auto`: Choose best contrast automatically
    ///     - `.forceLight`/`.forceDark`: Always go in that direction
    ///     - `.preferLight`/`.preferDark`: Try preferred direction first, switch only if target is unreachable
    /// - Returns: A contrasting shade of the input color that meets the target contrast ratio
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto
    ) throws -> Color {
        // contrastingShade is just contrastingColor against itself
        return try contrastingColor(color, against: color, using: method, targetRatio: targetRatio, direction: direction)
    }
    
    /// Optimizes one color to work well against another background.
    /// **Use Case 2**: "I have blue and red, which version of red looks best against blue?"
    ///
    /// Example:
    /// ```swift
    /// let optimizedRed = Garnish.contrastingColor(.red, against: .blue)
    /// let shadowRed = Garnish.contrastingColor(.red, against: .blue, direction: .forceDark)
    /// let whiteishText = Garnish.contrastingColor(.gray, against: .green, direction: .preferLight)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The color to optimize
    ///   - background: The background color to optimize against
    ///   - method: Brightness calculation method (default: .luminance)
    ///   - targetRatio: Minimum contrast ratio (default: WCAG AA = 4.5)
    ///   - direction: Direction preference (default: .auto)
    ///     - `.auto`: Choose best contrast automatically
    ///     - `.forceLight`/`.forceDark`: Always go in that direction
    ///     - `.preferLight`/`.preferDark`: Try preferred direction first, switch only if target is unreachable
    /// - Returns: Optimized version of the input color
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto
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
        
        // Determine the base color to blend with
        let blackBase: PlatformColor = .black
        let whiteBase: PlatformColor = .white

        let contrastingBase: PlatformColor

        switch direction {
        case .forceDark:
            contrastingBase = blackBase
        case .forceLight:
            contrastingBase = whiteBase
        case .auto:
            // Test the maximum achievable contrast in each direction by fully blending
            let fullyBlack = platformColor.blend(with: blackBase, ratio: 1.0)
            let fullyWhite = platformColor.blend(with: whiteBase, ratio: 1.0)

            let maxBlackRatio = try GarnishMath.contrastRatio(between: Color(fullyBlack), and: background)
            let maxWhiteRatio = try GarnishMath.contrastRatio(between: Color(fullyWhite), and: background)

            // Choose the direction with the highest potential contrast
            contrastingBase = maxBlackRatio > maxWhiteRatio ? blackBase : whiteBase

        case .preferLight, .preferDark:
            // Try the preferred direction first
            let preferredBase = direction == .preferLight ? whiteBase : blackBase
            let alternateBase = direction == .preferLight ? blackBase : whiteBase

            // Check if fully blending with preferred base can meet target
            let fullyBlended = platformColor.blend(with: preferredBase, ratio: 1.0)
            let maxRatio = try GarnishMath.contrastRatio(between: Color(fullyBlended), and: background)

            print("🔍 Debug Prefer Mode:")
            print("  Direction: \(direction)")
            print("  Preferred base: \(direction == .preferLight ? "WHITE" : "BLACK")")
            print("  Max ratio achievable: \(String(format: "%.2f", maxRatio))")
            print("  Target ratio: \(String(format: "%.2f", targetRatio))")
            print("  Can meet target: \(maxRatio >= targetRatio)")
            print("  Chosen base: \(maxRatio >= targetRatio ? (direction == .preferLight ? "WHITE" : "BLACK") : (direction == .preferLight ? "BLACK" : "WHITE"))")

            // If preferred direction can meet target, use it; otherwise switch to alternate
            contrastingBase = maxRatio >= targetRatio ? preferredBase : alternateBase
        }
        
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
            if bestRatio >= targetRatio && abs(bestRatio - targetRatio) < 0.05 {
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
