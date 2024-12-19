//
//  adjustForBackground.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//
import SwiftUI

extension Garnish {
    /// Produces a color suitable for use as a foreground against a given background color or a default assumption
    /// based on the color scheme.
    ///
    /// - If `backgroundColor` is provided, the function tries to ensure the returned color contrasts sufficiently
    ///   against it.
    /// - If `backgroundColor` is not provided, it assumes a default (white for light scheme, black for dark scheme)
    ///   and adjusts accordingly, similar to the original logic.
    /// - The function measures the contrast (via luminance difference) and chooses whether to blend heavily or lightly.
    /// - You can adjust thresholds and blend ratios to meet your desired contrast requirements (such as WCAG ratios).
    ///
    /// Example:
    /// ```swift
    /// let backgroundColor = Garnish.adjustForBackground(
    ///     for: .blue,
    ///     in: .light,
    ///     backgroundColor: .white
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - color: The input color to evaluate and adjust.
    ///   - scheme: The color scheme (`.light` or `.dark`) that influences default assumptions.
    ///   - backgroundColor: An optional background color against which to ensure contrast. If not provided,
    ///                      white is assumed for light mode and black is assumed for dark mode.
    ///   - blendAmount: The primary ratio to blend the input color with the contrast-improving color
    ///                  when adjustments are necessary (default: 0.60).
    ///   - lightBlendRatio: The ratio to blend when contrast is insufficient but not severely lacking in a light scheme (default: 0.1).
    ///   - darkBlendRatio: The ratio to blend when contrast is insufficient but not severely lacking in a dark scheme (default: 0.3).
    /// - Returns: A `Color` that is adjusted to ensure better contrast with the background.
    public static func adjustForBackground(
        for color: Color,
        in scheme: ColorScheme? = nil,
        with backgroundColor: Color? = nil,
        blendAmount: CGFloat = 0.80,
        lightBlendRatio: CGFloat = 0.1,
        darkBlendRatio: CGFloat = 0.3,
        debugStatements: Bool = false
    ) -> Color {
        let bgUIColor: UIColor
            if let backgroundColor = backgroundColor {
                bgUIColor = UIColor(backgroundColor).resolvedColor(with: UITraitCollection(userInterfaceStyle: Garnish.colorScheme))
            } else {
                bgUIColor = scheme == .dark ? .black : .white
            }
            let bgColor = Color(bgUIColor)
        
        // Determine scheme dynamically based on the background color's brightness
        let calcScheme: ColorScheme = isLightColor(bgColor, debug: backgroundColor == Color(.systemBackground)) ? .light : .dark
        
        // Compute contrast ratio
        let contrast = luminanceContrastRatio(between: color, and: bgColor)
        
        // Base color for contrast improvement
        let contrastImprovingBase = calcScheme == .light ? UIColor.black : UIColor.white
        
        
        // Define thresholds for blending
        let heavyBlendThreshold: CGFloat = 3.0
        let lightBlendThreshold: CGFloat = 4.5
        
        // Adjust the color based on contrast thresholds
        let adjusted: UIColor
        if contrast < heavyBlendThreshold {
            // Poor contrast, blend heavily
            adjusted = UIColor(color).blend(with: contrastImprovingBase, ratio: blendAmount)
        } else if contrast < lightBlendThreshold {
            // Medium contrast, blend lightlyx
            let ratio = calcScheme == .light ? lightBlendRatio : darkBlendRatio
            adjusted = UIColor(color).blend(with: contrastImprovingBase, ratio: ratio)
        } else {
            // Sufficient contrast, no adjustment needed
            adjusted = UIColor(color)
        }
        
        return Color(adjusted)
    }
    
}

#Preview{
    if #available(iOS 16.4, *) {
        GarnishModifierExampels()
    }
}


#Preview{
    if #available(iOS 16.4, *) {
        GarnishTestView()
    }
}
