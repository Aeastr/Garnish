import SwiftUI
import Foundation
import CoreData
import Observation

/// Observable theme manager for SwiftUI apps
@Observable
public class GarnishTheme {
    
    // MARK: - Color Properties (Stored)
    public var primary: Color = Color(red: 123/255, green: 67/255, blue: 204/255)
    public var secondary: Color = Color(red: 147/255, green: 99/255, blue: 230/255)
    public var tertiary: Color = Color(red: 180/255, green: 147/255, blue: 242/255)
    public var background: Color = Color(red: 252/255, green: 250/255, blue: 255/255)
    public var backgroundSecondary: Color = Color(red: 247/255, green: 242/255, blue: 252/255)
    
    // MARK: - Internal State
    @ObservationIgnored private var currentTheme: BuiltInTheme?
    @ObservationIgnored private var colorScheme: ColorScheme = .light {
        didSet { refreshColors() }
    }
    @ObservationIgnored private let currentThemeKey = "garnish_current_theme"
    
    /// Computed property to access CoreData context
    private var context: NSManagedObjectContext {
        return GarnishThemePersistence.shared.context
    }
    
    public init() {
        // Initialize with default purple theme
        configure(theme: createDefaultTheme())
        
        // Load saved theme from UserDefaults
        loadSavedTheme()
    }
    
    // MARK: - Configuration
    
    /// Configure the theme with a specific built-in theme
    public func configure(theme: BuiltInTheme) {
        currentTheme = theme
        refreshColors()
        
        // Save to UserDefaults
        UserDefaults.standard.set(theme.name, forKey: currentThemeKey)
    }
    
    /// Configure with a user-created theme
    public func configure(theme: GarnishThemeEntity) {
        let builtInTheme = convertToBuiltIn(theme)
        configure(theme: builtInTheme)
    }
    
    /// Update just the color scheme (light/dark mode)
    public func setColorScheme(_ scheme: ColorScheme) {
        colorScheme = scheme
    }
    
    /// Get current color scheme
    public var currentColorScheme: ColorScheme {
        colorScheme
    }
    
    /// Get current theme name
    public var currentThemeName: String {
        currentTheme?.name ?? "Default"
    }
    
    // MARK: - Generic Color Access
    
    /// Get color for any ColorKey
    public func color(_ key: ColorKey) -> Color {
        switch key {
        case .primary: return primary
        case .secondary: return secondary
        case .tertiary: return tertiary
        case .background: return background
        case .backgroundSecondary: return backgroundSecondary
        case .custom(_):
            // For custom keys, try to get from current theme, fallback to primary
            if let theme = currentTheme,
               let color = try? theme.color(key, for: colorScheme) {
                return color
            }
            return primary
        }
    }
    
    // MARK: - Private Methods
    
    /// Refresh all color properties from current theme
    private func refreshColors() {
        guard let theme = currentTheme else { return }
        
        do {
            primary = try theme.primary(for: colorScheme)
            secondary = try theme.secondary(for: colorScheme)
            tertiary = try theme.tertiary(for: colorScheme)
            background = try theme.background(for: colorScheme)
            backgroundSecondary = try theme.backgroundSecondary(for: colorScheme)
        } catch {
            // Fallback to system colors if theme is incomplete
            setSystemFallbackColors()
        }
    }
    
    /// Create the default purple theme
    private func createDefaultTheme() -> BuiltInTheme {
        let theme = BuiltInTheme(name: "Default")
        theme.setColor(.primary, Color(red: 123/255, green: 67/255, blue: 204/255), for: .light)
        theme.setColor(.secondary, Color(red: 147/255, green: 99/255, blue: 230/255), for: .light)
        theme.setColor(.tertiary, Color(red: 180/255, green: 147/255, blue: 242/255), for: .light)
        theme.setColor(.background, Color(red: 252/255, green: 250/255, blue: 255/255), for: .light)
        theme.setColor(.backgroundSecondary, Color(red: 247/255, green: 242/255, blue: 252/255), for: .light)
        theme.setColor(.primary, Color(red: 147/255, green: 99/255, blue: 230/255), for: .dark)
        theme.setColor(.secondary, Color(red: 180/255, green: 147/255, blue: 242/255), for: .dark)
        theme.setColor(.tertiary, Color(red: 199/255, green: 170/255, blue: 248/255), for: .dark)
        theme.setColor(.background, Color(red: 24/255, green: 18/255, blue: 32/255), for: .dark)
        theme.setColor(.backgroundSecondary, Color(red: 36/255, green: 28/255, blue: 44/255), for: .dark)
        return theme
    }
    
    /// Load saved theme from UserDefaults
    private func loadSavedTheme() {
        let themeName = UserDefaults.standard.string(forKey: currentThemeKey) ?? "Default"
        
        // Try to load built-in theme first
        if let builtInTheme = GarnishTheme.builtInThemes[themeName] {
            currentTheme = builtInTheme
            refreshColors()
            return
        }
        
        // Try to load user theme
        do {
            let userTheme = try loadUserTheme(named: themeName)
            let builtInTheme = convertToBuiltIn(userTheme)
            currentTheme = builtInTheme
            refreshColors()
        } catch {
            // Fallback to default theme if loading fails
            currentTheme = createDefaultTheme()
            refreshColors()
        }
    }
    
    /// Set system fallback colors
    private func setSystemFallbackColors() {
        primary = colorScheme == .light ? .primary : .white
        secondary = colorScheme == .light ? .secondary : .gray
        tertiary = colorScheme == .light ? .blue : .blue
        background = colorScheme == .light ? .white : .black
        backgroundSecondary = colorScheme == .light ? Color(.systemGray6) : Color(.systemGray5)
    }
    
    /// Convert user theme entity to built-in theme
    private func convertToBuiltIn(_ userTheme: GarnishThemeEntity) -> BuiltInTheme {
        let builtIn = BuiltInTheme(name: userTheme.name ?? "Unnamed")
        
        // Copy colors from user theme
        for colorKey in userTheme.definedColorKeys {
            if let lightColor = userTheme.color(for: colorKey, scheme: .light) {
                builtIn.setColor(colorKey, lightColor, for: .light)
            }
            if let darkColor = userTheme.color(for: colorKey, scheme: .dark) {
                builtIn.setColor(colorKey, darkColor, for: .dark)
            }
        }
        
        return builtIn
    }
    
    // MARK: - Theme Management
    
    /// Get all available built-in theme names
    public var availableBuiltInThemes: [String] {
        return GarnishTheme.builtInThemeNames
    }
    
    /// Create a new user theme (basic creation)
    public func create(_ name: String) throws -> GarnishThemeEntity {
        // Check if theme already exists
        if GarnishTheme.builtInThemes[name] != nil {
            throw GarnishThemeError.themeAlreadyExists(name)
        }
        
        if try themeExists(name: name) {
            throw GarnishThemeError.themeAlreadyExists(name)
        }
        
        return try GarnishThemePersistence.shared.createTheme(name: name)
    }
    
    /// Create a new user theme with colors
    public func createUserTheme(named name: String, colors: [ColorKey: [ColorScheme: Color]]) throws -> GarnishThemeEntity {
        let theme = try create(name)
        
        // Set colors for the theme
        for (colorKey, colorSchemeMap) in colors {
            let lightColor = colorSchemeMap[.light]
            let darkColor = colorSchemeMap[.dark]
            try GarnishThemePersistence.shared.setColor(for: theme, key: colorKey, light: lightColor, dark: darkColor)
        }
        
        // Save the theme
        try GarnishThemePersistence.shared.save()
        
        return theme
    }
    
    /// Load all user themes
    public func loadUserThemes() throws -> [GarnishThemeEntity] {
        return try GarnishThemePersistence.shared.fetchAllThemes()
    }
    
    /// Load a theme by name and apply it
    public func loadAndApplyTheme(named name: String) throws {
        // Check built-in themes first
        if let builtIn = GarnishTheme.builtInThemes[name] {
            configure(theme: builtIn)
            return
        }
        
        // Load from CoreData
        let userTheme = try loadUserTheme(named: name)
        configure(theme: userTheme)
    }
}

// MARK: - Database Methods

private extension GarnishTheme {
    func themeExists(name: String) throws -> Bool {
        return try GarnishThemePersistence.shared.themeExists(name: name)
    }
    
    func loadUserTheme(named name: String) throws -> GarnishThemeEntity {
        guard let coreDataEntity = try GarnishThemePersistence.shared.fetchTheme(name: name) else {
            throw GarnishThemeError.themeNotFound(name)
        }
        
        return coreDataEntity
    }
}

// MARK: - Static Compatibility (Deprecated)

public extension GarnishTheme {
    /// Legacy static access - deprecated, use instance with @Environment instead
    @available(*, deprecated, message: "Use @Environment(GarnishTheme.self) var theme instead")
    static let shared = GarnishTheme()
}
