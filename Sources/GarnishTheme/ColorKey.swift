import Foundation

/// Represents a color key for theme-based color management
public enum ColorKey: Hashable, Codable {
    case primary
    case secondary
    case tertiary
    case backgroundColor
    case custom(String)
}

// MARK: - Extensions for Type Safety
public extension ColorKey {
    /// Returns the string representation of the color key
    var stringValue: String {
        switch self {
        case .primary:
            return "primary"
        case .secondary:
            return "secondary"
        case .tertiary:
            return "tertiary"
        case .backgroundColor:
            return "backgroundColor"
        case .custom(let name):
            return name
        }
    }
    
    /// Creates a ColorKey from a string value
    /// - Parameter string: The string representation
    /// - Returns: ColorKey instance, or .custom(string) if not a standard key
    init(from string: String) {
        switch string {
        case "primary":
            self = .primary
        case "secondary":
            self = .secondary
        case "tertiary":
            self = .tertiary
        case "backgroundColor":
            self = .backgroundColor
        default:
            self = .custom(string)
        }
    }
    
    /// Returns true if this is a standard (built-in) color key
    var isStandard: Bool {
        switch self {
        case .primary, .secondary, .tertiary, .backgroundColor:
            return true
        case .custom:
            return false
        }
    }
}

// MARK: - Standard ColorKeys
public extension ColorKey {
    /// Standard color keys provided by GarnishTheme
    static let standardKeys: [ColorKey] = [
        .primary, .secondary, .tertiary, .backgroundColor
    ]
}