import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// NSValueTransformer for converting SwiftUI Color to/from Data for CoreData storage
@objc(ColorTransformer)
public class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    
    /// The transformer name for registration
    public static let name = NSValueTransformerName("ColorTransformer")
    
    /// Register the transformer with the system
    public static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    /// Returns the class types this transformer can handle
    public override class var allowedTopLevelClasses: [AnyClass] {
        return [NSData.self, NSString.self]
    }
    
    /// Transforms a SwiftUI Color to Data for storage
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? Color else {
            return nil
        }
        
        do {
            // Convert SwiftUI Color to platform color and extract components
            #if canImport(UIKit)
            let platformColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            guard platformColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
            
            #elseif canImport(AppKit)
            let platformColor = NSColor(color)
            guard let rgbColor = platformColor.usingColorSpace(.deviceRGB) else {
                return nil
            }
            
            let red = rgbColor.redComponent
            let green = rgbColor.greenComponent
            let blue = rgbColor.blueComponent
            let alpha = rgbColor.alphaComponent
            #endif
            
            // Create a dictionary with RGBA components
            let colorData: [String: Double] = [
                "red": Double(red),
                "green": Double(green),
                "blue": Double(blue),
                "alpha": Double(alpha)
            ]
            
            // Convert to JSON data
            return try JSONSerialization.data(withJSONObject: colorData)
            
        } catch {
            print("ColorTransformer: Failed to transform color to data: \(error)")
            return nil
        }
    }
    
    /// Transforms Data back to a SwiftUI Color
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        
        do {
            // Parse JSON data
            guard let colorData = try JSONSerialization.jsonObject(with: data) as? [String: Double] else {
                return nil
            }
            
            // Extract RGBA components
            guard let red = colorData["red"],
                  let green = colorData["green"],
                  let blue = colorData["blue"],
                  let alpha = colorData["alpha"] else {
                return nil
            }
            
            // Create SwiftUI Color
            return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            
        } catch {
            print("ColorTransformer: Failed to transform data to color: \(error)")
            return nil
        }
    }
    
    /// Indicates this transformer supports reverse transformation
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    /// The class this transformer produces
    public override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
}

// MARK: - Convenience Extensions

public extension ColorTransformer {
    
    /// Safely transform a Color to Data, throwing an error if transformation fails
    static func safeTransform(_ color: Color) throws -> Data {
        let transformer = ColorTransformer()
        guard let data = transformer.transformedValue(color) as? Data else {
            throw GarnishThemeError.colorTransformationFailed(.custom("unknown"))
        }
        return data
    }
    
    /// Safely transform Data back to a Color, throwing an error if transformation fails
    static func safeReverseTransform(_ data: Data) throws -> Color {
        let transformer = ColorTransformer()
        guard let color = transformer.reverseTransformedValue(data) as? Color else {
            throw GarnishThemeError.colorTransformationFailed(.custom("unknown"))
        }
        return color
    }
}