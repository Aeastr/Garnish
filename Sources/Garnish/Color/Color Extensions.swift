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

extension Color {
    /// Returns a new `Color` with its brightness (luminance) adjusted by the specified factor.
    /// - Parameter factor: A value by which to multiply the brightness. For example:
    ///   - A factor of 1.0 returns the same color.
    ///   - A factor of 0.5 makes the color darker.
    ///   - A factor of 1.5 makes the color brighter.
    /// - Returns: A new `Color` with adjusted brightness.
    func adjustingLuminance(by factor: CGFloat) -> Color {
        let uiColor = UIColor(self)
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract HSB components
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Adjust the brightness by the given factor, clamping between 0 and 1.
        let newBrightness = max(min(brightness * factor, 3.0), 0.0)
        
        // Create a new UIColor with the adjusted brightness
        let adjustedUIColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        
        // Convert back to SwiftUI Color
        return Color(adjustedUIColor)
    }
    
    func toHex(alpha: Bool = false) -> String {
        guard let components = cgColor?.components else {
            print("Error: Unable to retrieve color components. `cgColor` might be nil.")
            return "DAD7CD"
        }
        
        if components.count < 3 {
            print("Error: Insufficient color components. Expected at least 3 components, but found \(components.count).")
            return "DAD7CD"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        } else {
            print("Warning: Alpha component not found. Using default alpha value of 1.0.")
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
