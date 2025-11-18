//
//  Garnish.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Chronicle

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
    /// - Returns: A contrasting shade of the input color that meets the target contrast ratio, or `nil` if processing fails.
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto,
        minimumBlend: CGFloat? = nil,
        blendStyle: BlendStyle? = nil,
        blendRange: ClosedRange<CGFloat>? = nil
    ) -> Color? {
        // contrastingShade is just contrastingColor against itself
        return contrastingColor(
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
    /// - Returns: Optimized version of the input color, or `nil` if processing fails.
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        direction: ContrastDirection = .auto,
        minimumBlend: CGFloat? = nil,
        blendStyle: BlendStyle? = nil,
        blendRange: ClosedRange<CGFloat>? = nil
    ) -> Color? {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif

        let platformColor = PlatformColor(color)

        // Calculate current contrast ratio
        guard let currentRatio = GarnishMath.contrastRatio(between: color, and: background) else {
            return nil
        }

        // If contrast is already sufficient, return original color
        if currentRatio >= targetRatio {
            return color
        }

        // Determine the base color to blend with
        guard let contrastingBase = determineContrastingBase(
            platformColor: platformColor,
            background: background,
            direction: direction,
            targetRatio: targetRatio
        ) else {
            return nil
        }

        // Determine the blend range to search within
        let searchRange = determineBlendRange(
            blendRange: blendRange,
            minimumBlend: minimumBlend,
            blendStyle: blendStyle
        )

        // Binary search for the right blend amount to achieve target contrast
        guard let bestBlend = findOptimalBlend(
            platformColor: platformColor,
            contrastingBase: contrastingBase,
            background: background,
            targetRatio: targetRatio,
            searchRange: searchRange
        ) else {
            return nil
        }

        let result = platformColor.blend(with: contrastingBase, ratio: bestBlend)
        return Color(result)
    }

    // MARK: - Private Helper Methods

    private static func determineContrastingBase<PlatformColor: PlatformColorProtocol>(
        platformColor: PlatformColor,
        background: Color,
        direction: ContrastDirection,
        targetRatio: CGFloat
    ) -> PlatformColor? {
        let blackBase: PlatformColor = .black
        let whiteBase: PlatformColor = .white

        switch direction {
        case .forceDark:
            return blackBase
        case .forceLight:
            return whiteBase
        case .auto:
            return determineAutoDirection(
                platformColor: platformColor,
                background: background,
                blackBase: blackBase,
                whiteBase: whiteBase
            )
        case .preferLight, .preferDark:
            return determinePreferredDirection(
                platformColor: platformColor,
                background: background,
                direction: direction,
                targetRatio: targetRatio,
                blackBase: blackBase,
                whiteBase: whiteBase
            )
        }
    }

    private static func determineAutoDirection<PlatformColor: PlatformColorProtocol>(
        platformColor: PlatformColor,
        background: Color,
        blackBase: PlatformColor,
        whiteBase: PlatformColor
    ) -> PlatformColor? {
        let fullyBlack = platformColor.blend(with: blackBase, ratio: 1.0)
        let fullyWhite = platformColor.blend(with: whiteBase, ratio: 1.0)

        guard let maxBlackRatio = GarnishMath.contrastRatio(between: Color(fullyBlack), and: background),
              let maxWhiteRatio = GarnishMath.contrastRatio(between: Color(fullyWhite), and: background) else {
            return nil
        }

        return maxBlackRatio > maxWhiteRatio ? blackBase : whiteBase
    }

    private static func determinePreferredDirection<PlatformColor: PlatformColorProtocol>(
        platformColor: PlatformColor,
        background: Color,
        direction: ContrastDirection,
        targetRatio: CGFloat,
        blackBase: PlatformColor,
        whiteBase: PlatformColor
    ) -> PlatformColor? {
        let preferredBase = direction == .preferLight ? whiteBase : blackBase
        let alternateBase = direction == .preferLight ? blackBase : whiteBase

        let fullyBlended = platformColor.blend(with: preferredBase, ratio: 1.0)
        guard let maxRatio = GarnishMath.contrastRatio(between: Color(fullyBlended), and: background) else {
            return nil
        }

        return maxRatio >= targetRatio ? preferredBase : alternateBase
    }

    private static func determineBlendRange(
        blendRange: ClosedRange<CGFloat>?,
        minimumBlend: CGFloat?,
        blendStyle: BlendStyle?
    ) -> ClosedRange<CGFloat> {
        if let blendRange = blendRange {
            return blendRange
        } else if let minimumBlend = minimumBlend {
            return minimumBlend...1.0
        } else if let blendStyle = blendStyle {
            return blendStyle.minimumBlend...1.0
        } else {
            return 0.0...1.0
        }
    }

    private static func findOptimalBlend<PlatformColor: PlatformColorProtocol>(
        platformColor: PlatformColor,
        contrastingBase: PlatformColor,
        background: Color,
        targetRatio: CGFloat,
        searchRange: ClosedRange<CGFloat>
    ) -> CGFloat? {
        var lowBlend: CGFloat = searchRange.lowerBound
        var highBlend: CGFloat = searchRange.upperBound
        var bestBlend: CGFloat = 0.0
        var bestRatio: CGFloat = 0.0
        let maxIterations = 5

        for _ in 0..<maxIterations {
            let testBlend = (lowBlend + highBlend) / 2.0
            let testColor = platformColor.blend(with: contrastingBase, ratio: testBlend)
            guard let testRatio = GarnishMath.contrastRatio(between: Color(testColor), and: background) else {
                return nil
            }

            if testRatio >= targetRatio && (bestRatio < targetRatio || testBlend < bestBlend) {
                bestBlend = testBlend
                bestRatio = testRatio
            }

            if testRatio >= targetRatio {
                highBlend = testBlend
            } else {
                lowBlend = testBlend
                if bestRatio < targetRatio {
                    bestBlend = testBlend
                    bestRatio = testRatio
                }
            }

            if bestRatio >= targetRatio && abs(bestRatio - targetRatio) < 0.05 {
                break
            }
        }

        return bestBlend
    }

    /// Quick accessibility check.
    /// - Returns: `true` if colors meet WCAG AA standards, `false` otherwise (including if color analysis fails)
    public static func hasGoodContrast(_ color1: Color, _ color2: Color) -> Bool {
        return GarnishMath.meetsWCAGAA(color1, color2)
    }
}


// Preview removed - demo views were moved to new GarnishDemo.swift
