//
//  Garnish Extensions.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

extension Color{
    
    func constratingForegroud() -> Color{
        return Garnish.contrastingForeground(for: self)
    }
    
    func adjustedForeground(colorScheme: ColorScheme) -> Color{
        return Garnish.adjustForBackground(for: self, in: colorScheme)
    }
}
