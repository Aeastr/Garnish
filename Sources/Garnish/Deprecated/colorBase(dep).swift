//
//  colorBase.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

// extension Garnish {
//    /// Produces a version of the input color that is blended with a base color (white or black),
//    /// determined by the provided color scheme.
//    ///
//    /// - If the scheme is `.light`, the input color is blended towards black.
//    /// - If the scheme is `.dark`, the input color is blended towards white.
//    ///
//    /// Example:
//    /// ```swift
//    /// let colorBase = Garnish.colorBase(for: .blue, in: .dark)
//    /// ```
//    ///
//    /// - Parameters:
//    ///   - color: The input color to adjust.
//    ///   - scheme: The color scheme (`.light` or `.dark`) that determines the base blending behavior.
//    ///   - blendAmount: The ratio to blend the input color with the base color (default: 0.90).
//    /// - Returns: A `Color` object that is tinted towards the appropriate base color for the given scheme.
//    public static func colorBase(for color: Color, in scheme: ColorScheme, blendAmount: CGFloat = 0.90) -> Color {
//        let uiColor = UIColor(color)
//        let base = scheme == .light ? UIColor.systemBackground : UIColor.primary
//
//        // We'll blend the input color with the chosen base.
//        // A high blend ratio means a subtle tint. Adjust these numbers as desired.
//        // For example: 0.9 base, 0.1 color.
//        // If light scheme -> mostly white with a hint of the color
//        // If dark scheme -> mostly black with a hint of the color
//        let tinted = uiColor.blend(with: base, ratio: blendAmount)
//        return Color(tinted)
//    }
// }
