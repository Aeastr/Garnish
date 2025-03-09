//
//  Garnish Font Exntensions.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

extension Color {
    func recommendedFontWeight(
        in scheme: ColorScheme? = nil,
        with backgroundColor: Color? = nil,
        fontWeightRange: [Font.Weight] = [.regular, .semibold, .bold, .black],
        debugStatements: Bool = false
    ) -> Font.Weight {
        return Garnish.recommendedFontWeight(
            for: self,
            in: scheme ?? .light, // Default to light if no scheme is provided
            with: backgroundColor,
            fontWeightRange: fontWeightRange,
            debugStatements: debugStatements
        )
    }
}


