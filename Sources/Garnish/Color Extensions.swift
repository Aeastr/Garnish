//
//  Color Extensions.swift
//  Garnish
//
//  Created by Aether on 15/12/2024.
//

import SwiftUI

public extension Color {
    /// Adjusts the brightness of a color by a specified percentage.
    ///
    /// - Parameters:
    ///   - percentage: The percentage to adjust the brightness by. Positive values lighten the color, and negative values darken it. Range: -1.0 to 1.0.
    /// - Returns: A new `Color` object with adjusted brightness.
    func adjustedBrightness(by percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract RGBA components
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Adjust brightness
        let factor = 1.0 + percentage
        let newRed = min(max(red * factor, 0), 1)
        let newGreen = min(max(green * factor, 0), 1)
        let newBlue = min(max(blue * factor, 0), 1)
        
        // Return adjusted color
        return Color(UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha))
    }
    
    /// Adjusts the brightness of a color with customizable multipliers and scheme-based directionality.
        ///
        /// - Parameters:
        ///   - percentage: The base percentage to adjust the brightness by. Positive values lighten the color, and negative values darken it. Range: -1.0 to 1.0.
        ///   - colorScheme: The color scheme (`.light` or `.dark`) to determine the adjustment direction.
        ///   - lightModeMultiplier: A multiplier applied to the percentage in light mode. Default is 1.0 (no extra adjustment).
        ///   - darkModeMultiplier: A multiplier applied to the percentage in dark mode. Default is 1.5 (harsher adjustment).
        /// - Returns: A new `Color` object with adjusted brightness.
        func adjustedBrightness(
            for colorScheme: ColorScheme,
            by percentage: CGFloat,
            lightModeMultiplier: CGFloat = 1.0,
            darkModeMultiplier: CGFloat = 1.5
        ) -> Color {
            let uiColor = UIColor(self)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            // Extract RGBA components
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            // Determine multiplier based on the color scheme
            let multiplier = colorScheme == .light ? lightModeMultiplier : darkModeMultiplier
            
            // Adjust percentage and apply directionality
            let adjustment = percentage * multiplier
            let factor = colorScheme == .light ? (1.0 + adjustment) : (1.0 - adjustment)
            
            // Calculate new color components
            let newRed = min(max(red * factor, 0), 1)
            let newGreen = min(max(green * factor, 0), 1)
            let newBlue = min(max(blue * factor, 0), 1)
            
            // Return adjusted color
            return Color(UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha))
        }
}
