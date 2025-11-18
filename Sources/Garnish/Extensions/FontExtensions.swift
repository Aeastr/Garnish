//
//  FontExtensions.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension Color {
    /// Recommends an appropriate font weight for this color when used as text.
    ///
    /// - Parameters:
    ///   - backgroundColor: The background color to contrast against
    ///   - fontWeightRange: Array of font weights to choose from (default: [.regular, .semibold])
    ///   - debugStatements: Whether to print debug information
    /// - Returns: Recommended font weight from the provided range
    /// - Throws: `GarnishError` if parameters are invalid or color analysis fails
    func recommendedFontWeight(
        against backgroundColor: Color,
        fontWeightRange: [Font.Weight] = [.regular, .semibold],
        debugStatements: Bool = false
    ) throws -> Font.Weight {
        // Validate font weight range
        guard !fontWeightRange.isEmpty else {
            throw GarnishError.invalidParameter("fontWeightRange", value: fontWeightRange)
        }

        // Use the new standardized math functions
        guard let contrast = GarnishMath.contrastRatio(between: self, and: backgroundColor) else {
            throw GarnishError.invalidColorCalculation("Failed to calculate contrast ratio")
        }

        if debugStatements {
            print("[Debug] Background: \(backgroundColor), Foreground: \(self), Contrast: \(contrast)")
        }

        // Define thresholds for font weight adjustments using WCAG standards
        let heavyWeightThreshold: CGFloat = 3.0 // Use heavier weights for very low contrast
        let lightWeightThreshold: CGFloat = GarnishMath.wcagAAThreshold // Use WCAG AA threshold

        // Decide font weight based on contrast thresholds
        if contrast < heavyWeightThreshold {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is very low, recommending heaviest weight in range.")
            }
            return fontWeightRange.last! // Safe because we validated array is not empty
        } else if contrast < lightWeightThreshold {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is medium, recommending middle weight in range.")
            }
            let middleIndex = fontWeightRange.count / 2
            return fontWeightRange[middleIndex]
        } else {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is sufficient, recommending lightest weight in range.")
            }
            return fontWeightRange.first! // Safe because we validated array is not empty
        }
    }
}
