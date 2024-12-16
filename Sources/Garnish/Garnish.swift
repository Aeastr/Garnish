// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

/// `Garnish` is a utility for generating colors suitable for various UI elements, such as backgrounds and foregrounds,
/// ensuring readability and visual harmony across light and dark themes.
public struct Garnish {
    
    /// Produces a color suitable for use as a background, dynamically adjusting based on the input color's brightness
    /// and the provided color scheme (light or dark).
    ///
    /// - If the input color is not excessively light or dark, it will be blended using a subtle ratio (`lightBlendRatio` or `darkBlendRatio`).
    /// - If the input color is very light or very dark, it will be blended more heavily using `blendAmount`.
    ///
    /// Example:
    /// ```swift
    /// let backgroundColor = Garnish.bgBase(
    ///     for: .blue,
    ///     in: .light
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - color: The input color to evaluate and adjust.
    ///   - scheme: The color scheme (`.light` or `.dark`) that determines the adjustment logic.
    ///   - blendAmount: The primary ratio to blend the input color with the base color when adjustments are necessary (default: 0.90).
    ///   - lightBlendRatio: The ratio to blend when the input color is not excessively bright in a light scheme (default: 0.1).
    ///   - darkBlendRatio: The ratio to blend when the input color is not excessively dark in a dark scheme (default: 0.3).
    /// - Returns: A `Color` object that is either the input color (unaltered) or adjusted to ensure better contrast
    ///            based on the color scheme.
    public static func bgBase(
        for color: Color,
        in scheme: ColorScheme,
        blendAmount: CGFloat = 0.90,
        lightBlendRatio: CGFloat = 0.1,
        darkBlendRatio: CGFloat = 0.3
    ) -> Color {
        let uiColor = UIColor(color)
        if scheme == .light {
            let base = UIColor.black
            
            // If the input color is too light, blend heavily towards black.
            // Otherwise, apply a lighter blend.
            let tinted = isLightColor(color)
            ? uiColor.blend(with: base, ratio: blendAmount)
            : uiColor.blend(with: base, ratio: lightBlendRatio)
            return Color(tinted)
        } else {
            let base = UIColor.white
            
            // If the input color is not dark enough, blend heavily towards white.
            // Otherwise, apply a lighter blend.
            let tinted = !isDarkColor(color)
            ? uiColor.blend(with: base, ratio: blendAmount)
            : uiColor.blend(with: base, ratio: darkBlendRatio)
            return Color(tinted)
        }
    }
    
    /// Produces a version of the input color that is blended with a base color (white or black),
    /// determined by the provided color scheme.
    ///
    /// - If the scheme is `.light`, the input color is blended towards black.
    /// - If the scheme is `.dark`, the input color is blended towards white.
    ///
    /// Example:
    /// ```swift
    /// let colorBase = Garnish.colorBase(for: .blue, in: .dark)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The input color to adjust.
    ///   - scheme: The color scheme (`.light` or `.dark`) that determines the base blending behavior.
    ///   - blendAmount: The ratio to blend the input color with the base color (default: 0.90).
    /// - Returns: A `Color` object that is tinted towards the appropriate base color for the given scheme.
    public static func colorBase(for color: Color, in scheme: ColorScheme, blendAmount: CGFloat = 0.90) -> Color {
        let uiColor = UIColor(color)
        let base = scheme == .light ? UIColor.black : UIColor.white
        
        // We'll blend the input color with the chosen base.
        // A high blend ratio means a subtle tint. Adjust these numbers as desired.
        // For example: 0.9 base, 0.1 color.
        // If light scheme -> mostly white with a hint of the color
        // If dark scheme -> mostly black with a hint of the color
        let tinted = uiColor.blend(with: base, ratio: blendAmount)
        return Color(tinted)
    }
    
    
    /// Produces a foreground color that has good contrast against the given background color.
    ///
    /// - If the background color is light, a tinted dark color is returned.
    /// - If the background color is dark, a tinted light color is returned.
    ///
    /// Example:
    /// ```swift
    /// let foregroundColor = Garnish.contrastingForeground(for: .blue, threshold: 0.5, blendAmount: 0.9)
    /// ```
    ///
    /// - Parameters:
    ///   - background: The background color to evaluate.
    ///   - threshold: The luminance threshold for determining if the background is light or dark (default: 0.5).
    ///   - blendAmount: The ratio to blend the foreground tint with the base color (default: 0.9).
    /// - Returns: A `Color` object that ensures readability against the given background.
    public static func contrastingForeground(for background: Color, threshold: CGFloat = 0.5, blendAmount : CGFloat = 0.9) -> Color {
        let uiBackground = UIColor(background)
        let luminance = uiBackground.relativeLuminance()
        
        // Threshold based on W3C guidelines - a common threshold is ~0.5
        // Colors above ~0.5 luminance are considered "light", below are "dark"
        
        if luminance > threshold {
            // background is light, so we need a dark foreground
            // We'll use tintedBase with the light scheme to get a dark color tinted by background
            return colorBase(for: background, in: .light, blendAmount: blendAmount)
        } else {
            // background is dark, need a light foreground
            return colorBase(for: background, in: .dark, blendAmount: blendAmount)
        }
    }
    
    /// Calculates the relative luminance of a color
    ///
    /// Example:
    /// ```swift
    /// let luminance = Garnish.relativeLuminance(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze.
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance.
    public static func relativeLuminance(of color: Color) -> CGFloat {
        return UIColor(color).relativeLuminance()
    }
    
    /// Calculates the brightness of a color using a simple RGB averaging heuristic.
    ///
    /// Example:
    /// ```swift
    /// let brightness = Garnish.brightness(of: .blue)
    /// ```
    ///
    /// - Parameter color: The input color to analyze.
    /// - Returns: A value between 0.0 and 1.0 representing the brightness.
    public static func brightness(of color: Color) -> CGFloat {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r + g + b) / 3.0
    }
    
    /// Determines if a color is considered "light" based on its relative luminance.
    ///
    /// Example:
    /// ```swift
    /// let isLight = Garnish.isLightColor(.blue)
    /// ```
    ///
    /// - Parameter color: The input color to evaluate.
    /// - Returns: A `Bool` indicating whether the color is light.
    public static func isLightColor(_ color: Color) -> Bool {
        return relativeLuminance(of: color) > 0.5
    }
    
    // Determines whether a color is better suited for a light or dark color scheme based on its relative luminance.
    ///
    /// This function evaluates the brightness of the given color using its relative luminance and returns:
    /// - `.light` if the color is light (relative luminance > 0.5)
    /// - `.dark` if the color is dark (relative luminance ≤ 0.5)
    ///
    /// Example:
    /// ```swift
    /// let scheme = Garnish.determineColorScheme(.blue)
    /// print(scheme) // Output: .dark
    /// ```
    ///
    /// - Parameter color: The input color to evaluate.
    /// - Returns: A `ColorScheme` (.light or .dark) indicating which scheme is better suited for the color.
    public static func determineColorScheme(_ color: Color) -> ColorScheme {
        return relativeLuminance(of: color) > 0.5 ? .light : .dark
    }
    
    /// Determines if a color is considered "dark" based on its relative luminance.
    ///
    /// Example:
    /// ```swift
    /// let isDark = Garnish.isDarkColor(.blue)
    /// ```
    ///
    /// - Parameter color: The input color to evaluate.
    /// - Returns: A `Bool` indicating whether the color is dark.
    public static func isDarkColor(_ color: Color) -> Bool {
        return relativeLuminance(of: color) < 0.5
    }
    
    /// Computes the contrast ratio between two colors using the WCAG formula.
    ///
    /// Example:
    /// ```swift
    /// let contrast = Garnish.contrastRatio(between: .blue, and: .white)
    /// ```
    ///
    /// - Parameters:
    ///   - color1: The first color.
    ///   - color2: The second color.
    /// - Returns: A contrast ratio as a `CGFloat`.
    public static func contrastRatio(between color1: Color, and color2: Color) -> CGFloat {
        let L1 = relativeLuminance(of: color1)
        let L2 = relativeLuminance(of: color2)
        let (light, dark) = L1 > L2 ? (L1, L2) : (L2, L1)
        return (light + 0.05) / (dark + 0.05)
    }
}

// MARK: - UIColor Extensions

fileprivate extension UIColor {
    
    /// Blends the current color with another color by a given ratio.
    ///
    /// - Ratio of `0.0` results in 100% of the original color.
    /// - Ratio of `1.0` results in 100% of the blended color.
    ///
    /// Example:
    /// ```swift
    /// let blendedColor = UIColor.red.blend(with: .blue, ratio: 0.5)
    /// ```
    ///
    /// - Parameters:
    ///   - other: The color to blend with.
    ///   - ratio: The blend ratio (0.0 to 1.0).
    /// - Returns: A new `UIColor` object that is the result of the blend.
    func blend(with other: UIColor, ratio: CGFloat) -> UIColor {
        var r1: CGFloat=0, g1: CGFloat=0, b1: CGFloat=0, a1: CGFloat=0
        var r2: CGFloat=0, g2: CGFloat=0, b2: CGFloat=0, a2: CGFloat=0
        
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1*(1-ratio) + r2*ratio
        let g = g1*(1-ratio) + g2*ratio
        let b = b1*(1-ratio) + b2*ratio
        let a = a1*(1-ratio) + a2*ratio
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Calculates the relative luminance of the current color
    ///
    /// Example:
    /// ```swift
    /// let luminance = UIColor.red.relativeLuminance()
    /// ```
    ///
    /// - Returns: A value between 0.0 and 1.0 representing the relative luminance.
    func relativeLuminance() -> CGFloat {
        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        func lum(_ v: CGFloat) -> CGFloat {
            return (v <= 0.03928) ? (v / 12.92) : pow((v+0.055)/1.055, 2.4)
        }
        
        return 0.2126*lum(r) + 0.7152*lum(g) + 0.0722*lum(b)
    }
}

#Preview{
    if #available(iOS 16.4, *) {
        GarnishTestView()
    } else {
        GarnishTestViewLeg()
    }
}
