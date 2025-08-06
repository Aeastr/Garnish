//
//  GarnishPlaygroundApp.swift
//  GarnishPlayground
//
//  Created by Aether on 05/08/2025.
//

import SwiftUI
import Garnish
import GarnishTheme
@main
struct GarnishPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Base", systemImage: "paintpalette") {
                    GarnishDemoApp()
                }
                Tab("Theme", systemImage: "wand.and.stars") {
                    GarnishThemeDemoApp()
                }
            }
        }
    }
}
