//
//  recomendedFontWeight.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

extension Garnish{
    /// **DEPRECATED**: This function will be removed in a future version.
    /// 
    /// **Migration Path**: Use the extension method instead:
    /// ```swift
    /// // Old way:
    /// let weight = try Garnish.recommendedFontWeight(for: textColor, with: backgroundColor)
    /// 
    /// // New way:
    /// let weight = try textColor.recommendedFontWeight(against: backgroundColor)
    /// ```
    /// 
    /// Recommends an appropriate font weight based on the contrast between foreground and background colors.
    /// 
    /// - Parameters:
    ///   - color: The foreground color (text color)
    ///   - backgroundColor: The background color to contrast against
    ///   - fontWeightRange: Array of font weights to choose from (must not be empty)
    ///   - debugStatements: Whether to print debug information
    /// - Returns: Recommended font weight from the provided range
    /// - Throws: `GarnishError.missingRequiredParameter` if backgroundColor is nil
    ///           `GarnishError.invalidParameter` if fontWeightRange is empty
    @available(*, deprecated, message: "Use textColor.recommendedFontWeight(against: backgroundColor) extension method instead")
    public static func recommendedFontWeight(
        for color: Color,
        with backgroundColor: Color,
        fontWeightRange: [Font.Weight] = [.regular, .semibold],
        debugStatements: Bool = false
    ) throws -> Font.Weight {
        
        // Validate font weight range
        guard !fontWeightRange.isEmpty else {
            throw GarnishError.invalidParameter("fontWeightRange", value: fontWeightRange)
        }
        
        // Use the new standardized math functions
        let contrast = GarnishMath.contrastRatio(between: color, and: backgroundColor)
        
        if debugStatements {
            print("[Debug] Background: \(backgroundColor), Foreground: \(color), Contrast: \(contrast)")
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


@available(iOS 16.4, *)
#Preview {
    FontDemo()
}
