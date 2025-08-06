import SwiftUI
import Foundation
import CoreData
/// Theme management utilities and static methods
public class GarnishTheme {
    
    /// Computed property to access CoreData context
    private static var context: NSManagedObjectContext {
        return GarnishThemePersistence.shared.context
    }
    
    // MARK: - Static Current Theme Management
    
    private static var _current: CurrentTheme?
    private static let currentThemeKey = "garnish_current_theme"
    
    /// The currently active theme with in-memory cached colors for fast access
    public static var current: CurrentTheme {
        if let current = _current {
            return current
        }
        
        // Load from UserDefaults on first access
        let themeName = UserDefaults.standard.string(forKey: currentThemeKey) ?? "Default"
        
        // Check built-in themes first
        if let builtInTheme = builtInThemes[themeName] {
            let currentTheme = CurrentTheme.from(builtIn: builtInTheme)
            _current = currentTheme
            return currentTheme
        }
        
        // Try loading user theme
        do {
            let userTheme = try loadUserTheme(named: themeName)
            let currentTheme = CurrentTheme.from(userCreated: userTheme)
            _current = currentTheme
            return currentTheme
        } catch {
            // Fallback to default built-in theme
            let defaultTheme = builtInThemes["Default"]!
            let currentTheme = CurrentTheme.from(builtIn: defaultTheme)
            _current = currentTheme
            return currentTheme
        }
    }
    
    /// Sets the current active theme (built-in) and updates cache
    public static func setCurrentTheme(_ theme: BuiltInTheme) throws {
        let currentTheme = CurrentTheme.from(builtIn: theme)
        _current = currentTheme
        UserDefaults.standard.set(theme.name, forKey: currentThemeKey)
    }
    
    /// Sets the current active theme (user-created) and updates cache
    public static func setCurrentTheme(_ theme: GarnishThemeEntity) throws {
        let currentTheme = CurrentTheme.from(userCreated: theme)
        _current = currentTheme
        UserDefaults.standard.set(theme.name ?? "Unnamed", forKey: currentThemeKey)
    }
    
    // MARK: - Fast Current Theme Access
    
    /// Fast access to current theme colors
    public static func currentColor(_ key: ColorKey, for scheme: ColorScheme) throws -> Color {
        return try current.color(key, for: scheme)
    }
    
    /// Fast access to current primary color
    public static func currentPrimary(for scheme: ColorScheme) throws -> Color {
        return try current.primary(for: scheme)
    }
    
    /// Fast access to current secondary color
    public static func currentSecondary(for scheme: ColorScheme) throws -> Color {
        return try current.secondary(for: scheme)
    }
    
    /// Fast access to current tertiary color
    public static func currentTertiary(for scheme: ColorScheme) throws -> Color {
        return try current.tertiary(for: scheme)
    }
    
    /// Fast access to current background color
    public static func currentBackgroundColor(for scheme: ColorScheme) throws -> Color {
        return try current.backgroundColor(for: scheme)
    }
    
    // MARK: - Theme Management
    
    /// Create a new user theme
    public static func create(_ name: String) throws -> GarnishThemeEntity {
        // Check if theme already exists
        if builtInThemes[name] != nil {
            throw GarnishThemeError.themeAlreadyExists(name)
        }
        
        if try themeExists(name: name) {
            throw GarnishThemeError.themeAlreadyExists(name)
        }
        
        return try GarnishThemePersistence.shared.createTheme(name: name)
    }
    
    /// Load a theme by name (built-in or user)
    public static func loadTheme(named name: String) throws -> CurrentTheme {
        // Check built-in themes first
        if let builtIn = builtInThemes[name] {
            return CurrentTheme.from(builtIn: builtIn)
        }
        
        // Load from CoreData
        let userTheme = try loadUserTheme(named: name)
        return CurrentTheme.from(userCreated: userTheme)
    }
    
}

// MARK: - Database Methods

private extension GarnishTheme {
    static func themeExists(name: String) throws -> Bool {
        return try GarnishThemePersistence.shared.themeExists(name: name)
    }
    
    static func loadUserTheme(named name: String) throws -> GarnishThemeEntity {
        guard let coreDataEntity = try GarnishThemePersistence.shared.fetchTheme(name: name) else {
            throw GarnishThemeError.themeNotFound(name)
        }
        
        return coreDataEntity
    }
    
    
}

