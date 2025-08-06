//
//  ColorConvenienceExtensions.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  Consolidated convenience extensions for Color - updated to use new API
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
    /// - Returns: A contrasting shade of this color
    /// - Throws: `GarnishError` if color analysis fails
    func contrastingShade() throws -> Color {
        return try Garnish.contrastingShade(of: self)
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
    /// - Returns: An optimized version of this color with better contrast
    /// - Throws: `GarnishError` if color analysis fails
    func optimized(against background: Color, targetRatio: CGFloat = GarnishMath.wcagAAThreshold) throws -> Color {
        return try Garnish.contrastingColor(self, against: background, targetRatio: targetRatio)
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
    /// - Returns: ColorClassification (.light or .dark)
    /// - Throws: `GarnishError` if color analysis fails
    func classify(threshold: CGFloat = 0.5, using method: GarnishMath.BrightnessMethod = .luminance) throws -> GarnishMath.ColorClassification {
        return try GarnishMath.classify(self, threshold: threshold, using: method)
    }
    
    /// Determines the optimal ColorScheme for this color.
    /// This is equivalent to calling `GarnishMath.colorScheme(for: self)`.
    ///
    /// Example:
    /// ```swift
    /// let scheme = try Color.blue.colorScheme()
    /// ```
    ///
    /// - Parameter method: Brightness calculation method (default: .luminance)
    /// - Returns: .light or .dark ColorScheme
    /// - Throws: `GarnishError` if color analysis fails
    func colorScheme(using method: GarnishMath.BrightnessMethod = .luminance) throws -> ColorScheme {
        return try GarnishMath.colorScheme(for: self, using: method)
    }
    
    /// Calculates the relative luminance of this color using WCAG 2.1 standards.
    /// This is equivalent to calling `GarnishMath.relativeLuminance(of: self)`.
    ///
    /// Example:
    /// ```swift
    /// let luminance = try Color.blue.relativeLuminance()
    /// ```
    ///
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance
    /// - Throws: `GarnishError` if color analysis fails
    func relativeLuminance() throws -> CGFloat {
        return try GarnishMath.relativeLuminance(of: self)
    }
    
    /// Calculates the brightness of this color using the specified method.
    /// This is equivalent to calling `GarnishMath.brightness(of: self, using: method)`.
    ///
    /// Example:
    /// ```swift
    /// let brightness = try Color.blue.brightness(using: .luminance)
    /// ```
    ///
    /// - Parameter method: Calculation method (default: .luminance)
    /// - Returns: A value between 0.0 and 1.0 representing brightness
    /// - Throws: `GarnishError` if color analysis fails
    func brightness(using method: GarnishMath.BrightnessMethod = .luminance) throws -> CGFloat {
        return try GarnishMath.brightness(of: self, using: method)
    }
    
    /// Calculates the contrast ratio between this color and another color using WCAG 2.1 standards.
    /// This is equivalent to calling `GarnishMath.contrastRatio(between: self, and: otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let ratio = try Color.white.contrastRatio(with: .black)
    /// // Returns ~21.0 (maximum possible contrast)
    /// ```
    ///
    /// - Parameter otherColor: The other color to compare against
    /// - Returns: Contrast ratio (1.0 to 21.0, where higher is better contrast)
    /// - Throws: `GarnishError` if color analysis fails
    func contrastRatio(with otherColor: Color) throws -> CGFloat {
        return try GarnishMath.contrastRatio(between: self, and: otherColor)
    }
    
    /// Checks if this color meets WCAG AA contrast requirements against another color.
    /// This is equivalent to calling `GarnishMath.meetsWCAGAA(self, otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let isAccessible = try Color.white.meetsWCAGAA(with: .black)
    /// // Returns: true
    /// ```
    ///
    /// - Parameter otherColor: The color to check contrast against
    /// - Returns: True if contrast ratio >= 4.5:1
    /// - Throws: `GarnishError` if color analysis fails
    func meetsWCAGAA(with otherColor: Color) throws -> Bool {
        return try GarnishMath.meetsWCAGAA(self, otherColor)
    }
    
    /// Checks if this color meets WCAG AAA contrast requirements against another color.
    /// This is equivalent to calling `GarnishMath.meetsWCAGAAA(self, otherColor)`.
    ///
    /// Example:
    /// ```swift
    /// let isAAA = try Color.white.meetsWCAGAAA(with: .black)
    /// // Returns: true
    /// ```
    ///
    /// - Parameter otherColor: The color to check contrast against
    /// - Returns: True if contrast ratio >= 7:1
    /// - Throws: `GarnishError` if color analysis fails
    func meetsWCAGAAA(with otherColor: Color) throws -> Bool {
        return try GarnishMath.meetsWCAGAAA(self, otherColor)
    }
}
