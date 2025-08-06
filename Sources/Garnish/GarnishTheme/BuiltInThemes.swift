import SwiftUI

/// Built-in themes provided by GarnishTheme
public extension GarnishTheme {
    
    /// Dictionary of all built-in themes
    static let builtInThemes: [String: BuiltInTheme] = [
        "Default": createDefaultTheme(),
        "Dark": createDarkTheme(),
        "Ocean": createOceanTheme()
    ]
    
    /// Get a built-in theme by name
    static func builtin(_ name: String) -> BuiltInTheme? {
        return builtInThemes[name]
    }
    
    /// List of all built-in theme names
    static var builtInThemeNames: [String] {
        return Array(builtInThemes.keys).sorted()
    }
}

// MARK: - Theme Definitions

private extension GarnishTheme {
    
    static func createDefaultTheme() -> BuiltInTheme {
        let theme = BuiltInTheme(name: "Default")
        
        // Standard light colors
        theme.setColor(.primary, Color.blue, for: .light)
        theme.setColor(.secondary, Color.green, for: .light)
        theme.setColor(.tertiary, Color.orange, for: .light)
        theme.setColor(.backgroundColor, Color.white, for: .light)
        
        // Standard dark colors  
        theme.setColor(.primary, Color.blue.opacity(0.8), for: .dark)
        theme.setColor(.secondary, Color.green.opacity(0.8), for: .dark)
        theme.setColor(.tertiary, Color.orange.opacity(0.8), for: .dark)
        theme.setColor(.backgroundColor, Color.black, for: .dark)
        
        return theme
    }
    
    static func createDarkTheme() -> BuiltInTheme {
        let theme = BuiltInTheme(name: "Dark")
        
        // Dark-first design
        theme.setColor(.primary, Color.white, for: .light)
        theme.setColor(.secondary, Color.gray, for: .light)
        theme.setColor(.tertiary, Color.blue, for: .light)
        theme.setColor(.backgroundColor, Color(red: 0.95, green: 0.95, blue: 0.95), for: .light)
        
        theme.setColor(.primary, Color.white, for: .dark)
        theme.setColor(.secondary, Color.gray.opacity(0.7), for: .dark)
        theme.setColor(.tertiary, Color.blue.opacity(0.9), for: .dark)
        theme.setColor(.backgroundColor, Color(red: 0.1, green: 0.1, blue: 0.1), for: .dark)
        
        return theme
    }
    
    static func createOceanTheme() -> BuiltInTheme {
        let theme = BuiltInTheme(name: "Ocean")
        
        // Ocean-inspired colors
        theme.setColor(.primary, Color(red: 0.0, green: 0.5, blue: 0.8), for: .light)
        theme.setColor(.secondary, Color(red: 0.0, green: 0.7, blue: 0.6), for: .light)
        theme.setColor(.tertiary, Color(red: 0.4, green: 0.8, blue: 1.0), for: .light)
        theme.setColor(.backgroundColor, Color(red: 0.97, green: 0.99, blue: 1.0), for: .light)
        
        theme.setColor(.primary, Color(red: 0.2, green: 0.6, blue: 0.9), for: .dark)
        theme.setColor(.secondary, Color(red: 0.1, green: 0.8, blue: 0.7), for: .dark)
        theme.setColor(.tertiary, Color(red: 0.5, green: 0.9, blue: 1.0), for: .dark)
        theme.setColor(.backgroundColor, Color(red: 0.05, green: 0.1, blue: 0.15), for: .dark)
        
        return theme
    }
}
