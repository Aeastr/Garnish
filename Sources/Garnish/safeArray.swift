//
//  safeArray.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//


import SwiftUI
internal extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
