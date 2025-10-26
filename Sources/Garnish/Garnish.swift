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

    /// Blend intensity presets for controlling how strongly colors are adjusted
    public enum BlendStyle {
        /// Minimal blending - just enough to meet target contrast
        case minimal
        /// Moderate blending - at least 50% blend towards chosen direction
        case moderate
        /// Strong blending - at least 70% blend towards chosen direction
        case strong
        /// Maximum blending - always 100% blend (pure white or black)
        case maximum

        var minimumBlend: CGFloat {
            switch self {
            case .minimal: return 0.0
            case .moderate: return 0.5
            case .strong: return 0.7
            case .maximum: return 1.0
            }
        }
    }

    // MARK: - Core API (New)

    /// Generates a contrasting shade of the same color that meets WCAG standards.
    /// **Use Case 1**: "I have blue, give me a shade of blue that looks good against blue"
    ///
    /// Example:
    /// ```swift
    /// let contrastingBlue = Garnish.contrastingShade(of: .blue)
    /// let shadowBlue = Garnish.contrastingShade(of: .blue, direction: .forceDark)
    /// let strongWhite = Garnish.contrastingShade(of: .blue, blendStyle: .strong)
    /// let customBlend = Garnish.contrastingShade(of: .blue, minimumBlend: 0.6)
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
    ///   - minimumBlend: Minimum blend amount (0.0-1.0). Overrides blendStyle if both provided.
    ///   - blendStyle: Preset blend intensity (minimal, moderate, strong, maximum)
    ///   - blendRange: Full control over blend range. Overrides minimumBlend and blendStyle.
    /// - Returns: A contrasting shade of the input color that meets the target contrast ratio
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto,
        minimumBlend: CGFloat? = nil,
        blendStyle: BlendStyle? = nil,
        blendRange: ClosedRange<CGFloat>? = nil
    ) throws -> Color {
        // contrastingShade is just contrastingColor against itself
        return try contrastingColor(
            color,
            against: color,
            using: method,
            targetRatio: targetRatio,
            direction: direction,
            minimumBlend: minimumBlend,
            blendStyle: blendStyle,
            blendRange: blendRange
        )
    }

    /// Optimizes one color to work well against another background.
    /// **Use Case 2**: "I have blue and red, which version of red looks best against blue?"
    ///
    /// Example:
    /// ```swift
    /// let optimizedRed = Garnish.contrastingColor(.red, against: .blue)
    /// let shadowRed = Garnish.contrastingColor(.red, against: .blue, direction: .forceDark)
    /// let strongWhite = Garnish.contrastingColor(.red, against: .blue, blendStyle: .strong)
    /// let customBlend = Garnish.contrastingColor(.red, against: .blue, minimumBlend: 0.6)
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
    ///   - minimumBlend: Minimum blend amount (0.0-1.0). Overrides blendStyle if both provided.
    ///   - blendStyle: Preset blend intensity (minimal, moderate, strong, maximum)
    ///   - blendRange: Full control over blend range. Overrides minimumBlend and blendStyle.
    /// - Returns: Optimized version of the input color
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto,
        minimumBlend: CGFloat? = nil,
        blendStyle: BlendStyle? = nil,
        blendRange: ClosedRange<CGFloat>? = nil
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

            // If preferred direction can meet target, use it; otherwise switch to alternate
            contrastingBase = maxRatio >= targetRatio ? preferredBase : alternateBase
        }

        // Determine the blend range to search within
        let searchRange: ClosedRange<CGFloat>
        if let blendRange = blendRange {
            // Explicit range provided - use it directly
            searchRange = blendRange
        } else if let minimumBlend = minimumBlend {
            // Minimum blend specified - search from minimum to 1.0
            searchRange = minimumBlend...1.0
        } else if let blendStyle = blendStyle {
            // Style preset specified - map to range
            searchRange = blendStyle.minimumBlend...1.0
        } else {
            // Default - search full range
            searchRange = 0.0...1.0
        }

        // Binary search for the right blend amount to achieve target contrast
        var lowBlend: CGFloat = searchRange.lowerBound
        var highBlend: CGFloat = searchRange.upperBound
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
