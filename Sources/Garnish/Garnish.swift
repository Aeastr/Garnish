// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

/// `Garnish` is a utility for generating colors suitable for various UI elements, such as backgrounds and foregrounds,
/// ensuring readability and visual harmony across light and dark themes.
public struct Garnish {
    @Environment(\.colorScheme) var colorScheme
    
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
    public static func isLightColor(_ color: Color, debug: Bool = false) -> Bool {
        if debug{
            print("is light \(relativeLuminance(of: color))")
        }
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
    
    /// Computes the contrast ratio between two UIColors.
    /// Contrast ratio is defined as (L1 + 0.05) / (L2 + 0.05), where L1 is the lighter color's luminance
    /// and L2 is the darker color's luminance.
    public static func luminanceContrastRatio(between c1: Color, and c2: Color) -> CGFloat {
        let l1 = relativeLuminance(of: c1)
        let l2 = relativeLuminance(of: c2)
        let maxLum = max(l1, l2)
        let minLum = min(l1, l2)
        return (maxLum + 0.05) / (minLum + 0.05)
    }

}



#Preview{
    if #available(iOS 16.4, *) {
        GarnishTestView()
    } else {
        GarnishTestViewLeg()
    }
}
