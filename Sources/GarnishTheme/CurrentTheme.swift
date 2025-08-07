import SwiftUI
import Foundation

/// Wrapper for current theme that can be either built-in or user-created
public enum CurrentTheme {
    case builtIn(BuiltInTheme)
    case userCreated(GarnishThemeEntity)
    
    /// The name of the current theme
    public var name: String {
        switch self {
        case .builtIn(let theme):
            return theme.name
        case .userCreated(let theme):
            return theme.name ?? "Unnamed"
        }
    }
    
    /// Whether this is a built-in theme
    public var isBuiltIn: Bool {
        switch self {
        case .builtIn:
            return true
        case .userCreated:
            return false
        }
    }
    
    /// Get color for a specific key and scheme
    public func color(_ key: ColorKey, for scheme: ColorScheme) throws -> Color {
        switch self {
        case .builtIn(let theme):
            return try theme.color(key, for: scheme)
        case .userCreated(let theme):
            guard let color = theme.color(for: key, scheme: scheme) else {
                throw GarnishThemeError.colorNotDefined(key, themeName: name)
            }
            return color
        }
    }
    
    /// Convenience accessors for standard colors
    public func primary(for scheme: ColorScheme) throws -> Color {
        return try color(.primary, for: scheme)
    }
    
    public func secondary(for scheme: ColorScheme) throws -> Color {
        return try color(.secondary, for: scheme)
    }
    
    public func tertiary(for scheme: ColorScheme) throws -> Color {
        return try color(.tertiary, for: scheme)
    }
    
    public func background(for scheme: ColorScheme) throws -> Color {
        return try color(.background, for: scheme)
    }
    
    public func backgroundSecondary(for scheme: ColorScheme) throws -> Color {
        return try color(.backgroundSecondary, for: scheme)
    }
    
    /// Get all defined color keys
    public var definedColorKeys: [ColorKey] {
        switch self {
        case .builtIn(let theme):
            return theme.definedColorKeys
        case .userCreated(let theme):
            return theme.definedColorKeys
        }
    }
    
    /// Get preview colors for theme selection UI
    public var previewColors: (primary: Color, secondary: Color, background: Color, backgroundSecondary: Color) {
        switch self {
        case .builtIn(let theme):
            return theme.previewColors
        case .userCreated(let theme):
            let scheme: ColorScheme = .light // Default to light for previews
            
            do {
                let primary = try color(.primary, for: scheme)
                let secondary = try color(.secondary, for: scheme)
                let background = try color(.background, for: scheme)
                let backgroundSecondary = try color(.backgroundSecondary, for: scheme)
                return (primary: primary, secondary: secondary, background: background, backgroundSecondary: backgroundSecondary)
            } catch {
                // Fallback colors if theme is incomplete
                return (primary: Color.blue, secondary: Color.green, background: Color.white, backgroundSecondary: Color.gray)
            }
        }
    }
}

// MARK: - Convenience Initializers

public extension CurrentTheme {
    /// Create from built-in theme
    static func from(builtIn theme: BuiltInTheme) -> CurrentTheme {
        return .builtIn(theme)
    }
    
    /// Create from user-created theme entity
    static func from(userCreated theme: GarnishThemeEntity) -> CurrentTheme {
        return .userCreated(theme)
    }
}
