//
//  FontExtensionsDeprecated.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  Deprecated font extension methods
//

import SwiftUI

public extension Color {
    /// **DEPRECATED**: Use `textColor.recommendedFontWeight(against: backgroundColor)` extension method instead.
    ///
    /// **Migration Path**: Use the new extension method:
    /// ```swift
    /// // Old way:
    /// let weight = textColor.recommendedFontWeight(in: .light, with: backgroundColor)
    ///
    /// // New way:
    /// let weight = try textColor.recommendedFontWeight(against: backgroundColor)
    /// ```
    ///
    /// Recommends an appropriate font weight based on the contrast between this color and background.
    ///
    /// - Parameters:
    ///   - scheme: Color scheme context (deprecated, no longer used)
    ///   - backgroundColor: The background color to contrast against (required)
    ///   - fontWeightRange: Array of font weights to choose from
    ///   - debugStatements: Whether to print debug information
    /// - Returns: Recommended font weight from the provided range
    @available(*, deprecated, message: "Use textColor.recommendedFontWeight(against: backgroundColor) extension method instead")
    func recommendedFontWeight(
        in scheme: ColorScheme? = nil,
        with backgroundColor: Color? = nil,
        fontWeightRange: [Font.Weight] = [.regular, .semibold, .bold, .black],
        debugStatements: Bool = false
    ) -> Font.Weight {
        // Provide fallback behavior for deprecated method
        guard let backgroundColor = backgroundColor else {
            if debugStatements {
                print("[Debug] No background color provided, returning middle weight from range.")
            }
            let middleIndex = fontWeightRange.count / 2
            return fontWeightRange[middleIndex]
        }

        // Use the new method internally, but catch errors and provide fallback
        do {
            return try self.recommendedFontWeight(
                against: backgroundColor,
                fontWeightRange: Array(fontWeightRange.prefix(2)), // Use first 2 weights for compatibility
                debugStatements: debugStatements
            )
        } catch {
            if debugStatements {
                print("[Debug] Error in font weight calculation: \(error), returning middle weight from range.")
            }
            let middleIndex = fontWeightRange.count / 2
            return fontWeightRange[middleIndex]
        }
    }

    /// **DEPRECATED**: Use `color.contrastingShade()` extension method instead.
    ///
    ///
    /// Returns a contrasting foreground color for this background color.
    /// Note: This method has a typo in the name and uses deprecated API internally.
    ///
    /// - Returns: A contrasting color suitable for use as foreground
    @available(*, deprecated, message: "Use color.contrastingShade() extension method instead")
    func constratingForegroud() -> Color {
        return Garnish.contrastingForeground(for: self)
    }
}
