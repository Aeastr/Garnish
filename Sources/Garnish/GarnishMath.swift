//
//  GarnishMath.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Chronicle
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Mathematical utilities for color analysis and contrast calculations.
/// Provides standardized, WCAG-compliant methods for luminance and contrast calculations.
public class GarnishMath {
    // MARK: - Brightness Calculation Methods

    /// Method for calculating color brightness/luminance
    public enum BrightnessMethod {
        /// WCAG 2.1 relative luminance calculation (recommended)
        case luminance
        /// Simple RGB averaging: (r + g + b) / 3
        case rgb
    }

    // MARK: - WCAG Standards

    /// WCAG AA contrast ratio threshold (4.5:1)
    public static let wcagAAThreshold: CGFloat = 4.5

    /// WCAG AAA contrast ratio threshold (7:1)
    public static let wcagAAAThreshold: CGFloat = 7.0

    /// Default contrast threshold used throughout Garnish
    public static let defaultThreshold: CGFloat = wcagAAThreshold

    // MARK: - Luminance Calculations

    /// Calculates the relative luminance of a color using WCAG 2.1 standards.
    /// This is the recommended method for accessibility-compliant color analysis.
    ///
    /// Example:
    /// ```swift
    /// let luminance = try GarnishMath.relativeLuminance(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance, or `nil` if calculation fails
    public static func relativeLuminance(of color: Color) -> CGFloat? {
        do {
            #if canImport(UIKit)
            return try UIColor(color).relativeLuminance()
            #elseif os(macOS)
            return try NSColor(color).relativeLuminance()
            #else
            Logger.shared.log("Platform not supported for luminance calculation", level: .error, metadata: [
                "subsystem": "Garnish",
                "operation": "relativeLuminance"
            ])
            return nil
            #endif
        } catch {
            Logger.shared.log("Failed to calculate relative luminance: \(error.localizedDescription)", level: .error, metadata: [
                "subsystem": "Garnish",
                "operation": "relativeLuminance"
            ])
            return nil
        }
    }

    /// Calculates brightness using simple RGB averaging.
    /// Less accurate than relativeLuminance but faster for non-accessibility use cases.
    ///
    /// Example:
    /// ```swift
    /// let brightness = try GarnishMath.rgbBrightness(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze
    /// - Returns: A value between 0.0 and 1.0 representing the brightness, or `nil` if calculation fails
    public static func rgbBrightness(of color: Color) -> CGFloat? {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            Logger.shared.log("Failed to extract color components", level: .error, metadata: [
                "subsystem": "Garnish",
                "operation": "rgbBrightness"
            ])
            return nil
        }
        return (r + g + b) / 3.0
        #elseif os(macOS)
        let nsColor = NSColor(color)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
            Logger.shared.log("Failed to convert to RGB color space", level: .error, metadata: [
                "subsystem": "Garnish",
                "operation": "rgbBrightness"
            ])
            return nil
        }
        return (rgbColor.redComponent + rgbColor.greenComponent + rgbColor.blueComponent) / 3.0
        #else
        Logger.shared.log("Platform not supported for RGB brightness calculation", level: .error, metadata: [
            "subsystem": "Garnish",
            "operation": "rgbBrightness"
        ])
        return nil
        #endif
    }

    /// Calculates brightness using the specified method.
    ///
    /// - Parameters:
    ///   - color: The color to analyze
    ///   - method: The calculation method to use
    /// - Returns: A value between 0.0 and 1.0 representing brightness, or `nil` if calculation fails
    public static func brightness(of color: Color, using method: BrightnessMethod = .luminance) -> CGFloat? {
        switch method {
        case .luminance:
            return relativeLuminance(of: color)
        case .rgb:
            return rgbBrightness(of: color)
        }
    }

    // MARK: - Contrast Calculations

    /// Computes the contrast ratio between two colors using WCAG 2.1 standards.
    /// Contrast ratio is defined as (L1 + 0.05) / (L2 + 0.05), where L1 is the
    /// lighter color's luminance and L2 is the darker color's luminance.
    ///
    /// Example:
    /// ```swift
    /// let ratio = GarnishMath.contrastRatio(between: .white, and: .black)
    /// // Returns ~21.0 (maximum possible contrast)
    /// ```
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: Contrast ratio (1.0 to 21.0, where higher is better contrast), or `nil` if calculation fails
    public static func contrastRatio(between color1: Color, and color2: Color) -> CGFloat? {
        guard let l1 = relativeLuminance(of: color1),
              let l2 = relativeLuminance(of: color2) else {
            return nil
        }
        let maxLum = max(l1, l2)
        let minLum = min(l1, l2)

        return (maxLum + 0.05) / (minLum + 0.05)
    }

    // MARK: - Color Classification

    /// Classification of a color as light or dark
    public enum ColorClassification {
        case light
        case dark

        /// Returns the corresponding SwiftUI ColorScheme
        public var colorScheme: ColorScheme {
            switch self {
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    /// Classifies a color as light or dark based on its brightness.
    ///
    /// - Parameters:
    ///   - color: The color to classify
    ///   - threshold: The brightness threshold (default: 0.5)
    ///   - method: The brightness calculation method to use
    /// - Returns: ColorClassification (.light or .dark), or `nil` if classification fails
    public static func classify(_ color: Color, threshold: CGFloat = 0.5, using method: BrightnessMethod = .luminance) -> ColorClassification? {
        guard let b = brightness(of: color, using: method) else { return nil }
        return b > threshold ? .light : .dark
    }

    /// Convenience function: Determines the optimal ColorScheme for a given color.
    ///
    /// - Parameters:
    ///   - color: The color to analyze
    ///   - method: The brightness calculation method to use
    /// - Returns: .light or .dark ColorScheme, or `nil` if analysis fails
    public static func colorScheme(for color: Color, using method: BrightnessMethod = .luminance) -> ColorScheme? {
        return classify(color, using: method)?.colorScheme
    }

    // MARK: - Contrast Validation

    /// Checks if two colors meet WCAG AA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 4.5:1, false if it doesn't meet the threshold or if calculation fails
    public static func meetsWCAGAA(_ color1: Color, _ color2: Color) -> Bool {
        guard let ratio = contrastRatio(between: color1, and: color2) else { return false }
        return ratio >= wcagAAThreshold
    }

    /// Checks if contrast ratio meets WCAG AA contrast requirements.
    ///
    /// - Parameters:
    ///   - ratio: Contrast Ratio
    /// - Returns: True if contrast ratio >= 4.5:1
    public static func meetsWCAGAA(_ ratio: CGFloat) -> Bool {
        return ratio >= wcagAAThreshold
    }

    /// Checks if two colors meet WCAG AAA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 7:1, false if it doesn't meet the threshold or if calculation fails
    public static func meetsWCAGAAA(_ color1: Color, _ color2: Color) -> Bool {
        guard let ratio = contrastRatio(between: color1, and: color2) else { return false }
        return ratio >= wcagAAAThreshold
    }

    /// Checks if contrast ratio meets WCAG AAA contrast requirements.
    ///
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: True if contrast ratio >= 7:1
    /// - Throws: `GarnishError` if color analysis fails
    public static func meetsWCAGAAA(_ ratio: CGFloat) -> Bool {
        return ratio >= wcagAAAThreshold
    }
}
