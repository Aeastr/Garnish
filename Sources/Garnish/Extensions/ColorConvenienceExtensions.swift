//
//  ColorConvenienceExtensions.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension Color {
    /// Returns a contrasting shade of this color that works well against itself.
    /// This is equivalent to calling `Garnish.contrastingShade(of: self)`.
    ///
    /// Example:
    /// ```swift
    /// let contrastingBlue = Color.blue.contrastingShade()
    /// ```
    ///
    /// - Parameter blendAmount: How much to blend toward the contrasting base (0.0-1.0, default: 0.8)
    /// - Returns: A contrasting shade of this color, or `nil` if processing fails
    func contrastingShade() -> Color? {
        return Garnish.contrastingShade(of: self)
    }

    /// Returns an optimized version of this color that works well against the specified background.
    /// This is equivalent to calling `Garnish.contrastingColor(self, against: background)`.
    ///
    /// Example:
    /// ```swift
    /// let optimizedRed = Color.red.optimized(against: .blue)
    /// ```
    ///
    /// - Parameters:
    ///   - background: The background color to optimize against
    ///   - targetRatio: Minimum contrast ratio to achieve (default: WCAG AA = 4.5)
    /// - Returns: An optimized version of this color with better contrast, or `nil` if processing fails
    func optimized(against background: Color, targetRatio: CGFloat = GarnishMath.wcagAAThreshold) -> Color? {
        return Garnish.contrastingColor(self, against: background, targetRatio: targetRatio)
    }

    // MARK: - GarnishMath Convenience Extensions

    /// Classifies this color as light or dark.
    /// This is equivalent to calling `GarnishMath.classify(self)`.
    ///
    /// Example:
    /// ```swift
    /// let classification = try Color.blue.classify()
    /// let isLight = classification == .light
    /// ```
    ///
    /// - Parameters:
    ///   - threshold: Brightness cutoff (default: 0.5)
    ///   - method: Brightness calculation method (default: .luminance)
    /// - Returns: ColorClassification (.light or .dark), or `nil` if classification fails
    func classify(threshold: CGFloat = 0.5, using method: GarnishMath.BrightnessMethod = .luminance) -> GarnishMath.ColorClassification? {
        return GarnishMath.classify(self, threshold: threshold, using: method)
    }

    /// Determines the optimal ColorScheme for this color.
    /// This is equivalent to calling `GarnishMath.colorScheme(for: self)`.
    ///
    /// Example:
    /// ```swift
    /// let scheme = Color.blue.colorScheme()
    /// ```
    ///
    /// - Parameter method: Brightness calculation method (default: .luminance)
    /// - Returns: .light or .dark ColorScheme, or `nil` if analysis fails
    func colorScheme(using method: GarnishMath.BrightnessMethod = .luminance) -> ColorScheme? {
        return GarnishMath.colorScheme(for: self, using: method)
    }

    /// Calculates the relative luminance of this color using WCAG 2.1 standards.
    /// This is equivalent to calling `GarnishMath.relativeLuminance(of: self)`.
    ///
    /// Example:
    /// ```swift
    /// let luminance = Color.blue.relativeLuminance()
    /// ```
    ///
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance, or `nil` if calculation fails
    func relativeLuminance() -> CGFloat? {
        return GarnishMath.relativeLuminance(of: self)
    }

    /// Calculates the brightness of this color using the specified method.
    /// This is equivalent to calling `GarnishMath.brightness(of: self, using: method)`.
    ///
    /// Example:
    /// ```swift
    /// let brightness = Color.blue.brightness(using: .luminance)
    /// ```
    ///
    /// - Parameter method: Calculation method (default: .luminance)
    /// - Returns: A value between 0.0 and 1.0 representing brightness, or `nil` if calculation fails
    func brightness(using method: GarnishMath.BrightnessMethod = .luminance) -> CGFloat? {
        return GarnishMath.brightness(of: self, using: method)
    }

    /// Calculates the contrast ratio between this color and another color using WCAG 2.1 standards.
    /// This is equivalent to calling `GarnishMath.contrastRatio(between: self, and: otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let ratio = Color.white.contrastRatio(with: .black)
    /// // Returns ~21.0 (maximum possible contrast)
    /// ```
    ///
    /// - Parameter otherColor: The other color to compare against
    /// - Returns: Contrast ratio (1.0 to 21.0, where higher is better contrast), or `nil` if calculation fails
    func contrastRatio(with otherColor: Color) -> CGFloat? {
        return GarnishMath.contrastRatio(between: self, and: otherColor)
    }

    /// Checks if this color meets WCAG AA contrast requirements against another color.
    /// This is equivalent to calling `GarnishMath.meetsWCAGAA(self, otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let isAccessible = Color.white.meetsWCAGAA(with: .black)
    /// // Returns: true
    /// ```
    ///
    /// - Parameter otherColor: The color to check contrast against
    /// - Returns: True if contrast ratio >= 4.5:1, false if it doesn't meet the threshold or if calculation fails
    func meetsWCAGAA(with otherColor: Color) -> Bool {
        return GarnishMath.meetsWCAGAA(self, otherColor)
    }

    /// Checks if this color meets WCAG AAA contrast requirements against another color.
    /// This is equivalent to calling `GarnishMath.meetsWCAGAAA(self, otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let isAAA = Color.white.meetsWCAGAAA(with: .black)
    /// // Returns: true
    /// ```
    ///
    /// - Parameter otherColor: The color to check contrast against
    /// - Returns: True if contrast ratio >= 7:1, false if it doesn't meet the threshold or if calculation fails
    func meetsWCAGAAA(with otherColor: Color) -> Bool {
        return GarnishMath.meetsWCAGAAA(self, otherColor)
    }
}
