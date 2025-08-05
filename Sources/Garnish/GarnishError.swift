import SwiftUI

/// Errors that can occur during Garnish color operations
public enum GarnishError: Error, LocalizedError {
    /// Failed to extract color components from the provided color
    case colorComponentExtractionFailed(Color)
    
    /// Failed to convert color to the required color space
    case colorSpaceConversionFailed(Color, targetSpace: String)
    
    /// Required parameter was not provided
    case missingRequiredParameter(String)
    
    /// Invalid parameter value provided
    case invalidParameter(String, value: Any)
    
    /// Color calculation resulted in invalid values
    case invalidColorCalculation(String)
    
    public var errorDescription: String? {
        switch self {
        case .colorComponentExtractionFailed(let color):
            return "Failed to extract color components from color: \(color). The color may be in an unsupported format."
            
        case .colorSpaceConversionFailed(let color, let targetSpace):
            return "Failed to convert color \(color) to \(targetSpace) color space."
            
        case .missingRequiredParameter(let parameter):
            return "Required parameter '\(parameter)' was not provided."
            
        case .invalidParameter(let parameter, let value):
            return "Invalid value '\(value)' provided for parameter '\(parameter)'."
            
        case .invalidColorCalculation(let operation):
            return "Color calculation failed during operation: \(operation)."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .colorComponentExtractionFailed:
            return "The color may be using a color space or format that is not supported for component extraction."
            
        case .colorSpaceConversionFailed:
            return "The color could not be converted to the required color space for processing."
            
        case .missingRequiredParameter:
            return "A required parameter was not provided to the function."
            
        case .invalidParameter:
            return "The provided parameter value is outside the expected range or format."
            
        case .invalidColorCalculation:
            return "The color calculation produced invalid or out-of-range values."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .colorComponentExtractionFailed:
            return "Try using a different color format or ensure the color is properly initialized."
            
        case .colorSpaceConversionFailed:
            return "Ensure the color is compatible with RGB color space operations."
            
        case .missingRequiredParameter(let parameter):
            return "Provide a valid value for the '\(parameter)' parameter."
            
        case .invalidParameter(let parameter, _):
            return "Check the documentation for valid values for the '\(parameter)' parameter."
            
        case .invalidColorCalculation:
            return "Check the input values and ensure they are within valid ranges."
        }
    }
}
