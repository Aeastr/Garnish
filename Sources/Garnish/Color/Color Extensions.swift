//
//  Color Extensions.swift
//  Garnish
//
//  Created by Aether on 15/12/2024.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
/// Type alias for the platform-specific color.
typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
/// Type alias for the platform-specific color.
typealias PlatformColor = NSColor
#endif

public extension Color {
    /// Adjusts the brightness of a color using standardized RGB brightness calculation.
    /// Uses the same method as GarnishColor.adjustBrightness for consistency.
    ///
    /// - Parameter factor: Brightness adjustment factor (1.0 = no change, >1.0 = brighter, <1.0 = darker)
    /// - Returns: A new Color with adjusted brightness
    func adjustedBrightness(by factor: CGFloat) -> Color {
        return GarnishColor.adjustBrightness(of: self, by: factor)
    }
    
    /// Adjusts the luminance of a color using WCAG-compliant relative luminance calculation.
    /// Uses the same method as GarnishColor.adjustLuminance for consistency.
    ///
    /// - Parameter factor: Luminance adjustment factor (1.0 = no change, >1.0 = brighter, <1.0 = darker)
    /// - Returns: A new Color with adjusted luminance
    func adjustedLuminance(by factor: CGFloat) -> Color {
        return GarnishColor.adjustLuminance(of: self, by: factor)
    }
    
    /// Returns the hexadecimal string representation of the Color.
    ///
    /// - Parameter alpha: If `true` returns an 8-character hex including the alpha
    ///                    component, otherwise returns a 6-character hex string.
    /// - Returns: A hexadecimal string for the color.
    func toHex(alpha: Bool = false) -> String {
        // Convert SwiftUI Color to a platform-specific color.
        let platformColor = PlatformColor(self)
        
        guard let components = platformColor.cgColor.components else {
            print("Error: Unable to retrieve color components. `cgColor` might be nil.")
            return "DAD7CD"
        }
        
        if components.count < 3 {
            print("Error: Insufficient color components. Expected at least 3 components, " +
                  "but found \(components.count).")
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
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255),
                          lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255))
        }
    }
}

