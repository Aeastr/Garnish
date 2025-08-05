//
//  adjustForBackground.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  REFACTORED: Now uses standardized foundation
//
import SwiftUI

extension Garnish {
    /// **DEPRECATED**: Use `Garnish.contrastingColor(_:against:)` instead.
    /// 
    /// This function has been refactored to use the new standardized foundation.
    /// The new API is cleaner and removes inappropriate default parameters.
    ///
    /// Example migration:
    /// ```swift
    /// // Old way:
    /// let adjusted = Garnish.adjustForBackground(for: .blue, with: .white)
    /// 
    /// // New way:
    /// let adjusted = Garnish.contrastingColor(.blue, against: .white)
    /// ```
    @available(*, deprecated, message: "Use Garnish.contrastingColor(_:against:) instead")
    public static func adjustForBackground(
        for color: Color,
        in scheme: ColorScheme? = nil,
        with backgroundColor: Color? = nil,
        blendAmount: CGFloat = 0.80,
        lightBlendRatio: CGFloat = 0.1,
        darkBlendRatio: CGFloat = 0.3,
        debugStatements: Bool = false
    ) -> Color {
        // Handle the problematic default parameter case
        guard let bgColor = backgroundColor else {
            // If no background provided, fall back to monochromatic contrast
            if debugStatements {
                print("[Garnish] Warning: No background color provided. Using contrastingShade instead.")
            }
            return contrastingShade(of: color)
        }
        
        // Use the new standardized API
        let targetRatio = GarnishMath.defaultThreshold // Use WCAG AA standard
        return contrastingColor(color, against: bgColor, targetRatio: targetRatio)
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
