//
//  GarnishColorExpansion.swift
//  GarnishExpansion
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Garnish

/// Handles all color array expansion and contraction operations
public struct GarnishColorExpansion {
    // MARK: - Expansion Methods

    /// Main expansion method using Harmonic Flow strategy
    /// Expands a source color array to a target count with family coherence
    public static func expand(_ colors: [Color], to targetCount: Int) -> [Color] {
        guard !colors.isEmpty && targetCount > 0 else { return [] }

        // Handle edge cases
        if colors.count >= targetCount {
            return contract(colors, to: targetCount)
        }

        if colors.count == 1 {
            return generateVariations(of: colors[0], count: targetCount)
        }

        return harmonicFlowExpansion(colors, to: targetCount)
    }

    /// Contracts a color array to a smaller size by intelligent sampling
    public static func contract(_ colors: [Color], to targetCount: Int) -> [Color] {
        guard targetCount > 0 else { return [] }
        guard colors.count > targetCount else { return colors }

        if targetCount == 1 {
            // Return the most representative color (middle by luminance)
            return [selectPrimaryColor(from: colors)]
        }

        // Sample evenly across the array
        var result: [Color] = []
        let step = Float(colors.count - 1) / Float(targetCount - 1)

        for i in 0..<targetCount {
            let index = min(Int(Float(i) * step), colors.count - 1)
            result.append(colors[index])
        }

        return result
    }

    /// Selects the most representative color from an array
    public static func selectPrimaryColor(from colors: [Color]) -> Color {
        guard !colors.isEmpty else { return .blue }

        if colors.count == 1 {
            return colors[0]
        }

        // Sort by luminance and pick the middle one
        // If we can't calculate luminance for some colors, just use the middle by index
        let colorsWithLuminance = colors.compactMap { color -> (Color, CGFloat)? in
            guard let luminance = color.relativeLuminance() else { return nil }
            return (color, luminance)
        }

        if !colorsWithLuminance.isEmpty {
            let sorted = colorsWithLuminance.sorted { $0.1 < $1.1 }
            return sorted[sorted.count / 2].0
        }

        // Fallback: just return the middle color by index
        return colors[colors.count / 2]
    }

    // MARK: - Specific Expansion Strategies

    /// Harmonic Flow: Creates smooth transitions with subtle variations
    private static func harmonicFlowExpansion(_ sourceColors: [Color], to targetCount: Int) -> [Color] {
        let baseRepeats = targetCount / sourceColors.count
        let remainder = targetCount % sourceColors.count
        var result: [Color] = []

        for (index, color) in sourceColors.enumerated() {
            let repeatsForThisColor = baseRepeats + (index < remainder ? 1 : 0)

            if repeatsForThisColor == 1 {
                result.append(color)
            } else {
                // Create variations
                let variations = generateSubtleVariations(of: color, count: repeatsForThisColor)
                result.append(contentsOf: variations)
            }
        }

        return result
    }

    /// Linear Interpolation: Smooth gradient between colors
    public static func linearInterpolation(_ colors: [Color], to targetCount: Int) -> [Color] {
        guard colors.count > 1 && targetCount > colors.count else {
            return expand(colors, to: targetCount)
        }

        var result: [Color] = []
        let step = Double(colors.count - 1) / Double(targetCount - 1)

        for i in 0..<targetCount {
            let position = Double(i) * step
            let lowerIndex = Int(position)
            let upperIndex = min(lowerIndex + 1, colors.count - 1)
            let fraction = position - Double(lowerIndex)

            if lowerIndex == upperIndex {
                result.append(colors[lowerIndex])
            } else {
                let interpolated = interpolateColors(colors[lowerIndex], colors[upperIndex], fraction: fraction)
                result.append(interpolated)
            }
        }

        return result
    }

    /// Simple Repeat: Just cycles through the colors
    public static func simpleRepeat(_ colors: [Color], to targetCount: Int) -> [Color] {
        guard !colors.isEmpty else { return [] }

        return (0..<targetCount).map { colors[$0 % colors.count] }
    }

    // MARK: - Variation Generation

    /// Generates variations of a single color
    public static func generateVariations(of color: Color, count: Int) -> [Color] {
        guard count > 0 else { return [] }
        if count == 1 { return [color] }

        let hsb = color.hsb
        var variations: [Color] = []

        for i in 0..<count {
            let progress = Double(i) / Double(count - 1)

            // Create variations in a harmonious way
            let hueShift = sin(progress * .pi * 2) * 30 // ±30° hue variation
            let satShift = cos(progress * .pi * 2) * 0.2 // ±20% saturation
            let brightShift = sin(progress * .pi * 3) * 0.2 // ±20% brightness

            var newHue = (hsb.hue + hueShift).truncatingRemainder(dividingBy: 360)
            if newHue < 0 { newHue += 360 }

            let newSat = max(0, min(1, hsb.saturation + satShift))
            let newBright = max(0.2, min(1, hsb.brightness + brightShift))

            variations.append(Color(hue: newHue / 360, saturation: newSat, brightness: newBright))
        }

        return variations
    }

    /// Generates subtle variations for harmonic flow
    private static func generateSubtleVariations(of color: Color, count: Int) -> [Color] {
        guard count > 0 else { return [] }
        if count == 1 { return [color] }

        let hsb = color.hsb
        var variations: [Color] = []

        for i in 0..<count {
            let progress = Double(i) / Double(count - 1)

            // Very subtle variations
            let hueShift = (progress - 0.5) * 10 // ±5° hue
            let satShift = (progress - 0.5) * 0.1 // ±5% saturation
            let brightShift = (progress - 0.5) * 0.1 // ±5% brightness

            var newHue = (hsb.hue + hueShift).truncatingRemainder(dividingBy: 360)
            if newHue < 0 { newHue += 360 }

            let newSat = max(0, min(1, hsb.saturation + satShift))
            let newBright = max(0.2, min(1, hsb.brightness + brightShift))

            variations.append(Color(hue: newHue / 360, saturation: newSat, brightness: newBright))
        }

        return variations
    }

    // MARK: - Helper Methods

    private static func interpolateColors(_ color1: Color, _ color2: Color, fraction: Double) -> Color {
        let hsb1 = color1.hsb
        let hsb2 = color2.hsb

        let hue = interpolateHue(from: hsb1.hue, to: hsb2.hue, progress: fraction)
        let saturation = hsb1.saturation + (hsb2.saturation - hsb1.saturation) * fraction
        let brightness = hsb1.brightness + (hsb2.brightness - hsb1.brightness) * fraction

        return Color(hue: hue / 360, saturation: saturation, brightness: brightness)
    }

    private static func interpolateHue(from startHue: Double, to endHue: Double, progress: Double) -> Double {
        let diff = endHue - startHue
        let shortestDiff = ((diff + 180).truncatingRemainder(dividingBy: 360)) - 180
        return startHue + shortestDiff * progress
    }

    // MARK: - Expansion for Specific Use Cases

    /// Expands a single color to a gradient mesh (4x4 = 16 colors by default)
    public static func expandToGradientMesh(from color: Color, size: Int = 16) -> [Color] {
        return generateVariations(of: color, count: size)
    }

    /// Expands colors specifically for gradient backgrounds
    public static func expandForGradient(_ colors: [Color]) -> [Color] {
        return expand(colors, to: 16) // 4x4 mesh
    }

    /// Contracts colors to a single solid color
    public static func contractToSolid(_ colors: [Color]) -> Color {
        return selectPrimaryColor(from: colors)
    }
}
