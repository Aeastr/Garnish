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
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        biasPreference: CGFloat = 0.0
    ) throws -> Color {
        // contrastingShade is just contrastingColor against itself
        return try contrastingColor(color, against: color, using: method, targetRatio: targetRatio, biasPreference: biasPreference)
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
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        biasPreference: CGFloat = 0.0 // +ve = bias white, -ve = bias black
    ) throws -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif

        let platformColor = PlatformColor(color)
        let currentRatio = try GarnishMath.contrastRatio(
            between: color,
            and: background
        )

        if currentRatio >= targetRatio {
            return color
        }

        let blackBase: PlatformColor = .black
        let whiteBase: PlatformColor = .white

        func quickBestBlend(for base: PlatformColor) throws -> (blend: CGFloat, ratio: CGFloat) {
            let testRatios: [CGFloat] = [0.5, 0.7, 0.8, 0.88]
            var bestBlend: CGFloat = 1
            var bestRatio: CGFloat = 0

            for ratio in testRatios {
                let testColor = platformColor.blend(with: base, ratio: ratio)
                let contrast = try GarnishMath.contrastRatio(
                    between: Color(testColor),
                    and: background
                )

                if contrast >= targetRatio {
                    if ratio < bestBlend {
                        bestBlend = ratio
                        bestRatio = contrast
                    }
                    break
                } else if contrast > bestRatio {
                    bestBlend = ratio
                    bestRatio = contrast
                }
            }
            return (bestBlend, bestRatio)
        }

        let whiteResult = try quickBestBlend(for: whiteBase)
        let blackResult = try quickBestBlend(for: blackBase)

        print("---")
        print("Target ratio: \(targetRatio)")
        print("Bias preference: \(biasPreference) (positive = white bias, negative = black bias)")
        print("White final blend: \(whiteResult.blend), ratio: \(whiteResult.ratio)")
        print("Black final blend: \(blackResult.blend), ratio: \(blackResult.ratio)")

        let finalChoice: (PlatformColor, CGFloat)
        if whiteResult.ratio >= targetRatio && blackResult.ratio >= targetRatio {
            // Calculate how far each is from the target
            let whiteDiff = abs(whiteResult.ratio - targetRatio)
            let blackDiff = abs(blackResult.ratio - targetRatio)

            // Apply bias: positive = white bias, negative = black bias
            let adjustedBlackDiff = blackDiff + max(0, -biasPreference)
            let adjustedWhiteDiff = whiteDiff + max(0, biasPreference)

            print("Original diffs → White: \(whiteDiff), Black: \(blackDiff)")
            print("Adjusted diffs → White: \(adjustedWhiteDiff), Black: \(adjustedBlackDiff)")

            if adjustedWhiteDiff <= adjustedBlackDiff {
                print("→ Choosing WHITE (meets target, ratio bias applied)")
                finalChoice = (whiteBase, whiteResult.blend)
            } else {
                print("→ Choosing BLACK (meets target, ratio bias applied)")
                finalChoice = (blackBase, blackResult.blend)
            }
        } else if whiteResult.ratio >= targetRatio {
            print("→ Choosing WHITE (only white meets target)")
            finalChoice = (whiteBase, whiteResult.blend)
        } else if blackResult.ratio >= targetRatio {
            print("→ Choosing BLACK (only black meets target)")
            finalChoice = (blackBase, blackResult.blend)
        } else {
            // Neither meets target → still apply bias
            let whiteDiff = abs(whiteResult.ratio - targetRatio)
            let blackDiff = abs(blackResult.ratio - targetRatio)

            let adjustedBlackDiff = blackDiff + max(0, -biasPreference)
            let adjustedWhiteDiff = whiteDiff + max(0, biasPreference)

            print("Neither meets target → applying bias")
            print("Original diffs → White: \(whiteDiff), Black: \(blackDiff)")
            print("Adjusted diffs → White: \(adjustedWhiteDiff), Black: \(adjustedBlackDiff)")

            if adjustedWhiteDiff <= adjustedBlackDiff {
                print("→ Choosing WHITE (bias applied, neither meets)")
                finalChoice = (whiteBase, whiteResult.blend)
            } else {
                print("→ Choosing BLACK (bias applied, neither meets)")
                finalChoice = (blackBase, blackResult.blend)
            }
        }
        print("---")

        let result = platformColor.blend(with: finalChoice.0, ratio: finalChoice.1)
        return Color(result)
    }
}



// Preview removed - demo views were moved to new GarnishDemo.swift
