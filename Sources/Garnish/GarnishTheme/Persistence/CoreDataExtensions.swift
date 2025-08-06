import SwiftUI
import CoreData

// MARK: - GarnishThemeColor Extensions

extension GarnishThemeColor {
    
    /// Computed property for SwiftUI Color light variant
    var lightSwiftUIColor: Color? {
        get {
            guard let data = lightColor as? Data else { return nil }
            return try? ColorTransformer.safeReverseTransform(data)
        }
        set {
            if let color = newValue {
                lightColor = try? ColorTransformer.safeTransform(color) as NSObject
            } else {
                lightColor = nil
            }
        }
    }
    
    /// Computed property for SwiftUI Color dark variant
    var darkSwiftUIColor: Color? {
        get {
            guard let data = darkColor as? Data else { return nil }
            return try? ColorTransformer.safeReverseTransform(data)
        }
        set {
            if let color = newValue {
                darkColor = try? ColorTransformer.safeTransform(color) as NSObject
            } else {
                darkColor = nil
            }
        }
    }
    
    /// Set both light and dark colors at once
    func setColors(light: Color?, dark: Color?) {
        lightSwiftUIColor = light
        darkSwiftUIColor = dark
    }
    
    /// Get color for specific scheme
    func color(for scheme: ColorScheme) -> Color? {
        switch scheme {
        case .light:
            return lightSwiftUIColor
        case .dark:
            return darkSwiftUIColor
        @unknown default:
            return lightSwiftUIColor
        }
    }
    
    /// Set color for specific scheme
    func setColor(_ color: Color?, for scheme: ColorScheme) {
        switch scheme {
        case .light:
            lightSwiftUIColor = color
        case .dark:
            darkSwiftUIColor = color
        @unknown default:
            lightSwiftUIColor = color
        }
    }
}

// MARK: - GarnishThemeEntity Extensions

extension GarnishThemeEntity {
    
    /// Get color for a specific key and scheme
    func color(for key: ColorKey, scheme: ColorScheme) -> Color? {
        guard let colors = colors as? Set<GarnishThemeColor> else { return nil }
        let colorEntity = colors.first { $0.key == key.stringValue }
        return colorEntity?.color(for: scheme)
    }
    
    /// Set color for a specific key and scheme
    func setColor(_ color: Color?, for key: ColorKey, scheme: ColorScheme) {
        guard let colors = colors as? Set<GarnishThemeColor> else { return }
        
        var colorEntity = colors.first { $0.key == key.stringValue }
        
        // Create new color entity if needed
        if colorEntity == nil {
            colorEntity = GarnishThemeColor(context: managedObjectContext!)
            colorEntity?.key = key.stringValue
            colorEntity?.theme = self
        }
        
        colorEntity?.setColor(color, for: scheme)
    }
    
    /// Set both light and dark colors for a key
    func setColors(for key: ColorKey, light: Color?, dark: Color?) {
        guard let colors = colors as? Set<GarnishThemeColor> else { return }
        
        var colorEntity = colors.first { $0.key == key.stringValue }
        
        // Create new color entity if needed
        if colorEntity == nil {
            colorEntity = GarnishThemeColor(context: managedObjectContext!)
            colorEntity?.key = key.stringValue
            colorEntity?.theme = self
        }
        
        colorEntity?.setColors(light: light, dark: dark)
    }
    
    /// Get all defined color keys
    var definedColorKeys: [ColorKey] {
        guard let colors = colors as? Set<GarnishThemeColor> else { return [] }
        return colors.compactMap { colorEntity in
            guard let key = colorEntity.key else { return nil }
            return ColorKey(from: key)
        }
    }
    
    /// Remove a color key
    func removeColor(for key: ColorKey) {
        guard let colors = colors as? Set<GarnishThemeColor> else { return }
        if let colorEntity = colors.first(where: { $0.key == key.stringValue }) {
            managedObjectContext?.delete(colorEntity)
        }
    }
    
    /// Update the updatedAt timestamp
    func touch() {
        updatedAt = Date()
    }
}