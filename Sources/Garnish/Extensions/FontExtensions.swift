//
//  FontExtensions.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  Consolidated and updated from Garnish Functions folder
//

import SwiftUI

public extension Color {
    /// Recommends an appropriate font weight for this color when used as text.
    /// 
    /// - Parameters:
    ///   - backgroundColor: The background color to contrast against
    ///   - fontWeightRange: Array of font weights to choose from (default: [.regular, .semibold])
    ///   - debugStatements: Whether to print debug information
    /// - Returns: Recommended font weight from the provided range
    /// - Throws: `GarnishError` if parameters are invalid or color analysis fails
    func recommendedFontWeight(
        against backgroundColor: Color,
        fontWeightRange: [Font.Weight] = [.regular, .semibold],
        debugStatements: Bool = false
    ) throws -> Font.Weight {
        return try Garnish.recommendedFontWeight(
            for: self,
            with: backgroundColor,
            fontWeightRange: fontWeightRange,
            debugStatements: debugStatements
        )
    }
}
