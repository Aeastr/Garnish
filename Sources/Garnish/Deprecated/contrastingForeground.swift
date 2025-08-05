//
//  contrastingForeground.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  REFACTORED: Now uses standardized foundation
//

import SwiftUI

public extension Garnish {
    /// **DEPRECATED**: Use `Garnish.contrastingShade(of:)` instead.
    /// 
    /// This function has been refactored to use the new standardized foundation.
    /// The new API is cleaner and uses WCAG-compliant calculations.
    ///
    /// Example migration:
    /// ```swift
    /// // Old way:
    /// let foreground = Garnish.contrastingForeground(for: .blue)
    /// 
    /// // New way:
    /// let foreground = Garnish.contrastingShade(of: .blue)
    /// ```
    @available(*, deprecated, message: "Use Garnish.contrastingShade(of:) instead")
    public static func contrastingForeground(
        for background: Color,
        threshold: CGFloat = 0.5,
        blendAmount: CGFloat = 0.8
    ) -> Color {
        // Use the new standardized API with equivalent behavior
        return contrastingShade(of: background, blendAmount: blendAmount)
    }
}

