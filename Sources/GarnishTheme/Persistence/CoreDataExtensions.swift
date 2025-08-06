import SwiftUI
import CoreData

// MARK: - GarnishThemeColor Extensions

extension GarnishThemeColor {
    
    /// Computed property for SwiftUI Color light variant
    var lightSwiftUIColor: Color? {
        get {
            // Check if any component is actually set (not just defaults)
            guard hasLightColor else { return nil }
            return Color(.sRGB, red: lightColorR, green: lightColorG, blue: lightColorB, opacity: lightColorA)
        }
    }
    
    /// Set the light SwiftUI Color, throwing an error if color extraction fails
    func setLightColor(_ color: Color?) throws {
        if let color = color {
            // Try direct CGColor extraction first
            if let cgColor = color.cgColor,
               let components = cgColor.components,
               components.count >= 3 {
                lightColorR = Double(components[0])
                lightColorG = Double(components[1]) 
                lightColorB = Double(components[2])
                lightColorA = components.count >= 4 ? Double(components[3]) : 1.0
                return
            }
            
            // Fallback: Extract RGBA components via platform color conversion
            #if canImport(UIKit)
            let platformColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            guard platformColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                throw GarnishThemeError.colorTransformationFailed(.custom("light - failed to extract RGBA from UIColor"))
            }
            
            lightColorR = Double(red)
            lightColorG = Double(green)
            lightColorB = Double(blue)
            lightColorA = Double(alpha)
            
            #elseif canImport(AppKit)
            let platformColor = NSColor(color)
            guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
                throw GarnishThemeError.colorTransformationFailed(.custom("light - failed to convert to RGB colorspace"))
            }
            
            lightColorR = Double(rgbColor.redComponent)
            lightColorG = Double(rgbColor.greenComponent)
            lightColorB = Double(rgbColor.blueComponent)
            lightColorA = Double(rgbColor.alphaComponent)
            #endif
        } else {
            // Clear the color by setting all components to special "unset" values
            lightColorR = -1.0
            lightColorG = -1.0
            lightColorB = -1.0
            lightColorA = -1.0
        }
    }
    
    /// Computed property for SwiftUI Color dark variant
    var darkSwiftUIColor: Color? {
        get {
            guard hasDarkColor else { return nil }
            return Color(.sRGB, red: darkColorR, green: darkColorG, blue: darkColorB, opacity: darkColorA)
        }
    }
    
    /// Set the dark SwiftUI Color, throwing an error if color extraction fails
    func setDarkColor(_ color: Color?) throws {
        if let color = color {
            // Try direct CGColor extraction first
            if let cgColor = color.cgColor,
               let components = cgColor.components,
               components.count >= 3 {
                darkColorR = Double(components[0])
                darkColorG = Double(components[1])
                darkColorB = Double(components[2])
                darkColorA = components.count >= 4 ? Double(components[3]) : 1.0
                return
            }
            
            // Fallback: Extract RGBA components via platform color conversion
            #if canImport(UIKit)
            let platformColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            guard platformColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                throw GarnishThemeError.colorTransformationFailed(.custom("dark - failed to extract RGBA from UIColor"))
            }
            
            darkColorR = Double(red)
            darkColorG = Double(green)
            darkColorB = Double(blue)
            darkColorA = Double(alpha)
            
            #elseif canImport(AppKit)
            let platformColor = NSColor(color)
            guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
                throw GarnishThemeError.colorTransformationFailed(.custom("dark - failed to convert to RGB colorspace"))
            }
            
            darkColorR = Double(rgbColor.redComponent)
            darkColorG = Double(rgbColor.greenComponent)
            darkColorB = Double(rgbColor.blueComponent)
            darkColorA = Double(rgbColor.alphaComponent)
            #endif
        } else {
            darkColorR = -1.0
            darkColorG = -1.0
            darkColorB = -1.0
            darkColorA = -1.0
        }
    }
    
    /// Check if light color is actually set (vs just default values)
    var hasLightColor: Bool {
        return lightColorR >= 0 && lightColorG >= 0 && lightColorB >= 0 && lightColorA >= 0
    }
    
    /// Check if dark color is actually set (vs just default values)
    var hasDarkColor: Bool {
        return darkColorR >= 0 && darkColorG >= 0 && darkColorB >= 0 && darkColorA >= 0
    }
    
    /// Set both light and dark colors at once
    func setColors(light: Color?, dark: Color?) throws {
        try setLightColor(light)
        try setDarkColor(dark)
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
    func setColor(_ color: Color?, for scheme: ColorScheme) throws {
        switch scheme {
        case .light:
            try setLightColor(color)
        case .dark:
            try setDarkColor(color)
        @unknown default:
            try setLightColor(color)
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
    func setColor(_ color: Color?, for key: ColorKey, scheme: ColorScheme) throws {
        guard let colors = colors as? Set<GarnishThemeColor> else { return }
        
        var colorEntity = colors.first { $0.key == key.stringValue }
        
        // Create new color entity if needed
        if colorEntity == nil {
            colorEntity = GarnishThemeColor(context: managedObjectContext!)
            colorEntity?.key = key.stringValue
            colorEntity?.theme = self
        }
        
        try colorEntity?.setColor(color, for: scheme)
    }
    
    /// Set both light and dark colors for a key
    func setColors(for key: ColorKey, light: Color?, dark: Color?) throws {
        guard let colors = colors as? Set<GarnishThemeColor> else { return }
        
        var colorEntity = colors.first { $0.key == key.stringValue }
        
        // Create new color entity if needed
        if colorEntity == nil {
            colorEntity = GarnishThemeColor(context: managedObjectContext!)
            colorEntity?.key = key.stringValue
            colorEntity?.theme = self
        }
        
        try colorEntity?.setColors(light: light, dark: dark)
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
