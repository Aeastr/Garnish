import SwiftUI

/// Infrastructure for built-in themes that users can define for their apps
public extension GarnishTheme {
    
    /// Dictionary of all built-in themes (user-defined)
    static var builtInThemes: [String: BuiltInTheme] = [:]
    
    /// Get a built-in theme by name
    static func builtin(_ name: String) -> BuiltInTheme? {
        return builtInThemes[name]
    }
    
    /// Register a built-in theme for use in the app
    static func registerBuiltInTheme(_ theme: BuiltInTheme) {
        builtInThemes[theme.name] = theme
    }
    
    /// Remove a registered built-in theme
    static func unregisterBuiltInTheme(named name: String) {
        builtInThemes.removeValue(forKey: name)
    }
    
    /// List of all registered built-in theme names
    static var builtInThemeNames: [String] {
        return Array(builtInThemes.keys).sorted()
    }
}
