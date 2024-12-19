//
//  recomendedFontWeight.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

extension Garnish{
    public static func recommendedFontWeight(
        for color: Color,
        in scheme: ColorScheme? = nil,
        with backgroundColor: Color? = nil,
        fontWeightRange: [Font.Weight] = [.regular, .semibold],
        debugStatements: Bool = false
    ) -> Font.Weight {
        let bgColor = backgroundColor ?? (scheme == .dark ? Color.black : Color.white)
        
        // Determine scheme dynamically based on the background color's brightness
        let calcScheme: ColorScheme = isLightColor(bgColor, debug: debugStatements) ? .light : .dark
        
        // Compute contrast ratio
        let contrast = self.luminanceContrastRatio(between: color, and: bgColor)
        
        if debugStatements {
            print("[Debug] Background: \(bgColor), Foreground: \(color), Contrast: \(contrast), calcScheme \(calcScheme)")
        }
        
        // Define thresholds for font weight adjustments
        let heavyWeightThreshold: CGFloat = 3.0 // Use heavier weights for very low contrast
        let lightWeightThreshold: CGFloat = 3.5 // Use lighter weights for sufficient contrast
        
        // Decide font weight based on contrast thresholds
        if contrast < heavyWeightThreshold {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is very low, recommending heaviest weight in range.")
            }
            return fontWeightRange.last ?? .bold // Default to heaviest in the range
        } else if contrast < lightWeightThreshold {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is medium, recommending middle weight in range.")
            }
            return fontWeightRange[safe: fontWeightRange.count / 2] ?? .regular // Default to middle weight in the range
        } else {
            if debugStatements {
                print("[Debug] Contrast \(contrast) is sufficient, recommending lightest weight in range.")
            }
            return fontWeightRange.first ?? .light // Default to lightest in the range
        }
    }
}


@available(iOS 16.4, *)
#Preview {
    FontDemo()
}
