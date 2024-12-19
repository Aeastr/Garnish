//
//  contrastingForeground.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

extension Garnish {
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
    public static func contrastingForeground(for background: Color, threshold: CGFloat = 0.5, blendAmount : CGFloat = 0.8) -> Color {
        let uiBackground = UIColor(background)
        let luminance = uiBackground.relativeLuminance()
        
        // Threshold based on W3C guidelines - a common threshold is ~0.5
        // Colors above ~0.5 luminance are considered "light", below are "dark"
        
        if luminance > threshold {
            // background is light, so we need a dark foreground
            let base = UIColor.black
            
            // We'll blend the input color with the chosen base.
            let tinted = uiBackground.blend(with: base, ratio: blendAmount)
            
            return Color(tinted)
        } else {
            // background is dark, need a light foreground
            let base = UIColor.white
            
            // We'll blend the input color with the chosen base.
            let tinted = uiBackground.blend(with: base, ratio: blendAmount)
            
            return Color(tinted)
        }
    }
}
