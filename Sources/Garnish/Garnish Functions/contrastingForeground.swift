//
//  contrastingForeground.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension Garnish {
    /// Produces a foreground color that has good contrast against the given background color.
    ///
    /// - If the background color is light, a tinted dark color is returned.
    /// - If the background color is dark, a tinted light color is returned.
    ///
    /// Example:
    /// ```swift
    /// let foregroundColor = Garnish.contrastingForeground(for: .blue,
    ///                                                      threshold: 0.5,
    ///                                                      blendAmount: 0.9)
    /// ```
    ///
    /// - Parameters:
    ///   - background: The background color to evaluate.
    ///   - threshold: The luminance threshold for determining if the background is light or dark (default: 0.5).
    ///   - blendAmount: The ratio to blend the foreground tint with the base color (default: 0.8).
    /// - Returns: A `Color` object that ensures readability against the given background.
    public static func contrastingForeground(for background: Color,
                                               threshold: CGFloat = 0.5,
                                               blendAmount: CGFloat = 0.8) -> Color {
        // Convert SwiftUI Color to PlatformColor
        let platformBG = PlatformColor(background)
        let luminance = platformBG.relativeLuminance()
        
        // Choose a base tint: black for light backgrounds, white for dark backgrounds.
        let base: PlatformColor = luminance > threshold ? .black : .white
        
        // Blend the original background color with the base tint using the specified blend amount.
        let tinted = platformBG.blend(with: base, ratio: blendAmount)
        
        // Return the result as a SwiftUI Color.
        return Color(tinted)
    }
}

