# Extensions

This folder contains all Swift extensions for the Garnish package, organized by the type being extended.

## Files

### Core Extensions
- `ColorExtensions.swift` - Core Color extensions for brightness adjustment, luminance adjustment, and hex conversion
- `UIColorExtensions.swift` - Platform-specific UIColor/NSColor extensions for blending and luminance calculations
- `ColorConvenienceExtensions.swift` - Convenience methods that provide instance-method access to main Garnish functionality

### Specialized Extensions
- `FontExtensions.swift` - Font-related extensions for weight recommendations based on color contrast

## Organization Principles

**Consolidated**: All extensions are in one logical location instead of scattered across multiple folders.

**Clear Naming**: File names clearly indicate what they extend and their purpose.

**Updated API**: All extensions use the new standardized Garnish API instead of deprecated functions.

**Proper Error Handling**: Extensions that can fail now use proper error throwing instead of silent fallbacks.

## Usage Examples

### Color Extensions
```swift
// Brightness and luminance adjustment
let brighterColor = color.adjustBrightness(by: 0.2)  // 20% brighter
let adjustedColor = color.adjustLuminance(by: 0.1)   // add 0.1 to HSB brightness

// Hex conversion
let hexString = try color.toHex(alpha: true)
```

### Convenience Extensions
```swift
// Get contrasting shade of the same color
let contrastingBlue = Color.blue.contrastingShade()

// Optimize color against a background
let optimizedRed = Color.red.optimized(against: .blue)
```

### Font Extensions
```swift
// Get recommended font weight for contrast
let weight = try textColor.recommendedFontWeight(against: backgroundColor)
```
