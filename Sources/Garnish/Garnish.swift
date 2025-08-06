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
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingShade(
        of color: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        blendAmount: CGFloat = 0.8
    ) throws -> Color {
        #if canImport(UIKit)
        typealias PlatformColor = UIColor
        #elseif os(macOS)
        typealias PlatformColor = NSColor
        #endif
        
        let platformColor = PlatformColor(color)
        let isLight = try GarnishMath.classify(color, using: method) == .light
        
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
    /// let harmonizedRed = Garnish.contrastingColor(.red, against: .blue, harmonize: true)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The color to optimize
    ///   - background: The background color to optimize against
    ///   - method: Brightness calculation method (default: .luminance)
    ///   - targetRatio: Minimum contrast ratio (default: WCAG AA = 4.5)
    ///   - harmonize: Whether to apply color harmony optimization (default: false)
    ///   - harmonyStrength: Strength of harmony adjustment when harmonize is true (default: 0.4)
    /// - Returns: Optimized version of the input color
    /// - Throws: `GarnishError` if color analysis fails
    public static func contrastingColor(
        _ color: Color,
        against background: Color,
        using method: GarnishMath.BrightnessMethod = .luminance,
        targetRatio: CGFloat = GarnishMath.defaultThreshold,
        harmonize: Bool = false,
        harmonyStrength: CGFloat = 0.4
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
        
        // Determine which direction to adjust (toward black or white)
        let backgroundIsLight = try GarnishMath.classify(background, using: method) == .light
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
        
        let contrastedColor = platformColor.blend(with: contrastingBase, ratio: bestBlend)
        let finalColor = Color(contrastedColor)
        
        // Apply harmony adjustment if requested
        if harmonize {
            return try self.harmonize(finalColor, with: background, adjustmentStrength: harmonyStrength)
        } else {
            return finalColor
        }
    }
    
    /// Quick accessibility check.
    /// - Throws: `GarnishError` if color analysis fails
    public static func hasGoodContrast(_ color1: Color, _ color2: Color) throws -> Bool {
        return try GarnishMath.meetsWCAGAA(color1, color2)
    }
    
    // MARK: - Color Harmony
    
    /// Harmonizes one color to work aesthetically with another using LCH color space.
    /// The reference color stays unchanged while the target color is adjusted for better harmony.
    ///
    /// Example:
    /// ```swift
    /// let harmonizedBlue = Garnish.harmonize(.blue, with: .red)
    /// // Blue is adjusted to work better with red, red stays the same
    /// ```
    ///
    /// - Parameters:
    ///   - color: The color to harmonize (will be adjusted)
    ///   - referenceColor: The reference color to harmonize with (stays unchanged)
    ///   - hueWeight: Importance of hue harmony (default: 0.5)
    ///   - temperatureWeight: Importance of temperature harmony (default: 0.3)
    ///   - chromaWeight: Importance of chroma harmony (default: 0.2)
    ///   - adjustmentStrength: How much to adjust the color (0.0-1.0, default: 0.6)
    /// - Returns: Harmonized version of the input color
    /// - Throws: `GarnishError` if color processing fails
    public static func harmonize(
        _ color: Color,
        with referenceColor: Color,
        hueWeight: CGFloat = 0.5,
        temperatureWeight: CGFloat = 0.3,
        chromaWeight: CGFloat = 0.2,
        adjustmentStrength: CGFloat = 0.6
    ) throws -> Color {
        let originalLCH = try GarnishMath.rgbToLCH(color)
        let referenceLCH = try GarnishMath.rgbToLCH(referenceColor)
        let currentScore = try GarnishMath.harmonyScore(
            between: color, 
            and: referenceColor,
            hueWeight: hueWeight,
            temperatureWeight: temperatureWeight,
            chromaWeight: chromaWeight
        )
        
        // If already harmonious, return with minimal adjustment
        if currentScore > 0.8 {
            return color
        }
        
        var bestLCH = originalLCH
        var bestScore = currentScore
        let maxIterations = 20
        
        // Try adjusting hue toward harmonious relationships
        let targetHues = calculateHarmoniousHues(from: referenceLCH.hue)
        
        for targetHue in targetHues {
            // Gradually adjust hue toward target
            let hueSteps = 5
            for i in 1...hueSteps {
                let blendRatio = CGFloat(i) / CGFloat(hueSteps) * adjustmentStrength
                let adjustedHue = interpolateHue(from: originalLCH.hue, to: targetHue, ratio: blendRatio)
                
                // Try different chroma adjustments
                let chromaAdjustments: [CGFloat] = [1.0, 0.8, 1.2, 0.6]
                for chromaFactor in chromaAdjustments {
                    let adjustedChroma = originalLCH.chroma * chromaFactor
                    
                    let candidateLCH = GarnishMath.LCHColor(
                        lightness: originalLCH.lightness,
                        chroma: adjustedChroma,
                        hue: adjustedHue
                    )
                    
                    let candidateRGB = GarnishMath.lchToRGB(candidateLCH)
                    
                    do {
                        let score = try GarnishMath.harmonyScore(
                            between: candidateRGB,
                            and: referenceColor,
                            hueWeight: hueWeight,
                            temperatureWeight: temperatureWeight,
                            chromaWeight: chromaWeight
                        )
                        
                        if score > bestScore {
                            bestScore = score
                            bestLCH = candidateLCH
                        }
                    } catch {
                        continue
                    }
                }
            }
        }
        
        return GarnishMath.lchToRGB(bestLCH)
    }
    
    /// Calculates harmonious hue angles relative to a reference hue
    /// - Parameter referenceHue: Reference hue angle (0-360°)
    /// - Returns: Array of potentially harmonious hue angles
    private static func calculateHarmoniousHues(from referenceHue: CGFloat) -> [CGFloat] {
        var harmonicHues: [CGFloat] = []
        
        // Analogous (±30°)
        harmonicHues.append((referenceHue + 30).truncatingRemainder(dividingBy: 360))
        harmonicHues.append((referenceHue - 30 + 360).truncatingRemainder(dividingBy: 360))
        
        // Complementary (180°)
        harmonicHues.append((referenceHue + 180).truncatingRemainder(dividingBy: 360))
        
        // Triadic (120°, 240°)
        harmonicHues.append((referenceHue + 120).truncatingRemainder(dividingBy: 360))
        harmonicHues.append((referenceHue + 240).truncatingRemainder(dividingBy: 360))
        
        // Split-complementary (150°, 210°)
        harmonicHues.append((referenceHue + 150).truncatingRemainder(dividingBy: 360))
        harmonicHues.append((referenceHue + 210).truncatingRemainder(dividingBy: 360))
        
        return harmonicHues
    }
    
    /// Interpolates between two hue angles, handling wraparound
    /// - Parameters:
    ///   - fromHue: Starting hue angle
    ///   - toHue: Target hue angle
    ///   - ratio: Interpolation ratio (0.0-1.0)
    /// - Returns: Interpolated hue angle
    private static func interpolateHue(from fromHue: CGFloat, to toHue: CGFloat, ratio: CGFloat) -> CGFloat {
        let diff = toHue - fromHue
        let normalizedDiff: CGFloat
        
        if diff > 180 {
            normalizedDiff = diff - 360
        } else if diff < -180 {
            normalizedDiff = diff + 360
        } else {
            normalizedDiff = diff
        }
        
        let result = fromHue + (normalizedDiff * ratio)
        return result < 0 ? result + 360 : result.truncatingRemainder(dividingBy: 360)
    }
}



// Preview removed - demo views were moved to new GarnishDemo.swift
