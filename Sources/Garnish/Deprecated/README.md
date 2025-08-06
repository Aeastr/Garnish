# Deprecated Functions

This folder contains deprecated functions and methods that are maintained for backward compatibility but should not be used in new code.

## Files

### Standalone Functions
- `adjustForBackground.swift` - **DEPRECATED**: Use `Garnish.contrastingColor(_:against:)` instead
- `contrastingForeground.swift` - **DEPRECATED**: Use `Garnish.contrastingShade(of:)` instead  
- `colorBase(dep).swift` - **REMOVED**: Already commented out, will be deleted in future version

### Extension Files
- `GarnishDeprecated.swift` - Deprecated methods for the main `Garnish` class
- `GarnishMathDeprecated.swift` - Deprecated methods for the `GarnishMath` class

## Migration Guide

### Core Functions
```swift
// OLD
let adjusted = Garnish.adjustForBackground(for: .blue, with: .white)
let foreground = Garnish.contrastingForeground(for: .blue)

// NEW
let adjusted = Garnish.contrastingColor(.blue, against: .white)
let foreground = Garnish.contrastingShade(of: .blue)
```

### Utility Functions
```swift
// OLD
let isLight = Garnish.isLightColor(.blue)
let isDark = Garnish.isDarkColor(.blue)
let scheme = Garnish.determineColorScheme(.blue)
let ratio = Garnish.luminanceContrastRatio(between: .blue, and: .white)

// NEW
let classification = Garnish.classify(.blue)
let isLight = classification == .light
let isDark = classification == .dark
let scheme = Garnish.colorScheme(for: .blue)
let ratio = Garnish.contrastRatio(between: .blue, and: .white)
```

## Timeline

These deprecated functions will be removed in a future major version. Please migrate to the new API as soon as possible.
