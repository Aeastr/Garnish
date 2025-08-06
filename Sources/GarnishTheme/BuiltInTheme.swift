import SwiftUI
import Foundation

/// A built-in theme that doesn't require CoreData persistence
public class BuiltInTheme {
    public let name: String
    public let isBuiltIn: Bool = true
    private var colors: [ColorKey: (light: Color?, dark: Color?)] = [:]
    
    internal init(name: String) {
        self.name = name
    }
    
    // MARK: - Color Access
    
    /// Get color for a specific ColorKey and ColorScheme
    public func color(_ key: ColorKey, for scheme: ColorScheme) throws -> Color {
        guard let colorPair = colors[key] else {
            throw GarnishThemeError.colorNotDefined(key, themeName: name)
        }
        
        let color = scheme == .light ? colorPair.light : colorPair.dark
        guard let color = color else {
            throw GarnishThemeError.colorNotDefined(key, themeName: name)
        }
        
        return color
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
    
    public func backgroundColor(for scheme: ColorScheme) throws -> Color {
        return try color(.backgroundColor, for: scheme)
    }
    
    // MARK: - Color Setting (Internal for built-in theme creation)
    
    /// Set color for both light and dark schemes
    internal func setColor(_ key: ColorKey, light: Color, dark: Color) {
        colors[key] = (light: light, dark: dark)
    }
    
    /// Set color for specific scheme only
    internal func setColor(_ key: ColorKey, _ color: Color, for scheme: ColorScheme) {
        let existing = colors[key] ?? (light: nil, dark: nil)
        if scheme == .light {
            colors[key] = (light: color, dark: existing.dark)
        } else {
            colors[key] = (light: existing.light, dark: color)
        }
    }
    
    // MARK: - Schema Information
    
    /// Returns all color keys defined in this theme
    public var definedColorKeys: [ColorKey] {
        return Array(colors.keys)
    }
    
    /// Checks if a color key is defined in this theme
    public func hasColor(_ key: ColorKey) -> Bool {
        return colors[key] != nil
    }
    
    /// Checks if a color key has both light and dark variants
    public func hasCompleteColor(_ key: ColorKey) -> Bool {
        guard let colorPair = colors[key] else { return false }
        return colorPair.light != nil && colorPair.dark != nil
    }
    
    /// Get preview colors for theme selection UI
    public var previewColors: (primary: Color, secondary: Color, background: Color) {
        let scheme: ColorScheme = .light // Default to light for previews
        
        do {
            let primary = try color(.primary, for: scheme)
            let secondary = try color(.secondary, for: scheme)
            let background = try color(.backgroundColor, for: scheme)
            return (primary: primary, secondary: secondary, background: background)
        } catch {
            // Fallback colors if theme is incomplete
            return (primary: Color.blue, secondary: Color.green, background: Color.white)
        }
    }
}