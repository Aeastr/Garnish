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
    func contrastingShade(blendAmount: CGFloat = 0.8) -> Color {
        return Garnish.contrastingShade(of: self, blendAmount: blendAmount)
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
    func optimized(against background: Color, targetRatio: CGFloat = GarnishMath.wcagAAThreshold) -> Color {
        return Garnish.contrastingColor(self, against: background, targetRatio: targetRatio)
    }
}
