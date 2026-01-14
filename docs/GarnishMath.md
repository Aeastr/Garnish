# GarnishMath

GarnishMath provides the mathematical foundation for all color analysis in Garnish. It implements WCAG 2.1 compliant calculations for luminance, contrast ratios, and color classification.

## 📐 Brightness Calculation Methods

### `BrightnessMethod` Enum

GarnishMath supports two approaches to calculating color brightness:

```swift
public enum BrightnessMethod {
    case luminance  // WCAG 2.1 relative luminance (recommended)
    case rgb        // Simple RGB averaging
}
```

**When to use each:**
- **`.luminance`** - For accessibility compliance and accurate perceptual brightness
- **`.rgb`** - For simple, fast calculations where precision isn't critical

---

## 🌟 Luminance Calculations

### `relativeLuminance(of:)`

Calculates WCAG 2.1 compliant relative luminance - the gold standard for accessibility.

```swift
// Class method
let luminance = GarnishMath.relativeLuminance(of: .blue)

// Extension method 
let luminance = Color.blue.relativeLuminance()
// Returns: 0.0722 (blue is quite dark)
```

**Technical Details:**
- Uses the WCAG 2.1 formula: `0.2126 * R + 0.7152 * G + 0.0722 * B`
- Accounts for sRGB gamma correction
- Returns values from 0.0 (black) to 1.0 (white)

### `rgbBrightness(of:)`

Simple RGB averaging for basic brightness calculation:

```swift
let brightness = GarnishMath.rgbBrightness(of: .blue)
// Returns: 0.333 (R=0, G=0, B=1 → average = 0.333)
```

### `brightness(of:using:)`

Unified brightness calculation with method selection:

```swift
// Class method
let luminanceBrightness = GarnishMath.brightness(of: .blue, using: .luminance)

// Extension method 
let brightness = Color.blue.brightness(using: .rgb)
```

---

## 📊 Contrast Calculations

### `contrastRatio(between:and:)`

Calculates WCAG 2.1 contrast ratio between two colors:

```swift
// Class method
let ratio = GarnishMath.contrastRatio(between: .white, and: .black)

// Extension method 
let ratio = Color.white.contrastRatio(with: .black)
// Returns: 21.0 (maximum possible contrast)
```

**Formula:** `(L1 + 0.05) / (L2 + 0.05)` where L1 is the lighter color's luminance

**Contrast Ratio Scale:**
- `1:1` - No contrast (same color)
- `4.5:1` - WCAG AA minimum
- `7:1` - WCAG AAA minimum  
- `21:1` - Maximum possible (white on black)

---

## 🎨 Color Classification

### `ColorClassification` Enum

```swift
public enum ColorClassification {
    case light
    case dark
    
    var colorScheme: ColorScheme { /* ... */ }
}
```

### `classify(_:threshold:using:)`

Classifies colors as light or dark:

```swift
// Class method
let classification = GarnishMath.classify(.blue)
// Returns: .dark

// Extension method 
let classification = Color.blue.classify()
// More natural syntax
```

**Parameters:**
- `threshold: CGFloat` - Brightness cutoff (default: 0.5)
- `method: BrightnessMethod` - Calculation method

### `colorScheme(for:using:)`

Direct ColorScheme determination:

```swift
// Class method
let scheme = GarnishMath.colorScheme(for: backgroundColor)

// Extension method
let scheme = try backgroundColor.colorScheme()
```

---

## ✅ WCAG Compliance Validation

### WCAG Standards

```swift
// Predefined thresholds
GarnishMath.wcagAAThreshold   // 4.5:1
GarnishMath.wcagAAAThreshold  // 7:1
GarnishMath.defaultThreshold  // 4.5:1 (AA)
```

### Compliance Checking

**Color-based validation:**
```swift
// Class method
let meetsAA = GarnishMath.meetsWCAGAA(.white, .blue)

// Extension method
let meetsAA = Color.white.meetsWCAGAA(with: .blue)
// Returns: true (8.6:1 > 4.5:1)
```

**Ratio-based validation:**
```swift
let ratio: CGFloat = 6.2
let meetsAA = GarnishMath.meetsWCAGAA(ratio)   // true
let meetsAAA = GarnishMath.meetsWCAGAAA(ratio) // false
```

---

## 🔬 Technical Implementation

### Platform Support

GarnishMath automatically handles platform differences:

```swift
#if canImport(UIKit)
// iOS, tvOS, visionOS
typealias PlatformColor = UIColor
#elseif os(macOS)
// macOS
typealias PlatformColor = NSColor
#endif
```

### Error Handling

All calculations are wrapped in proper error handling:

```swift
do {
    let luminance = GarnishMath.relativeLuminance(of: someColor)
} catch GarnishError.colorComponentExtractionFailed(let color) {
    print("Failed to analyze color: \(color)")
} catch GarnishError.colorSpaceConversionFailed(let color, let space) {
    print("Color space conversion failed: \(color) to \(space)")
}
```

---

## 🎯 Practical Examples

### Dynamic Theme Detection
```swift
func recommendedColorScheme(for backgroundColor: Color) -> ColorScheme {
    return GarnishMath.colorScheme(for: backgroundColor)
}
```

### Accessibility Audit
```swift
func auditColorPair(_ foreground: Color, _ background: Color) -> String {
    let ratio = GarnishMath.contrastRatio(between: foreground, and: background)
    
    if GarnishMath.meetsWCAGAAA(ratio) {
        return "✅ Excellent (AAA): \(String(format: "%.1f", ratio)):1"
    } else if GarnishMath.meetsWCAGAA(ratio) {
        return "✅ Good (AA): \(String(format: "%.1f", ratio)):1"
    } else {
        return "❌ Poor: \(String(format: "%.1f", ratio)):1"
    }
}
```

### Smart Color Selection
```swift
func bestTextColor(for background: Color) -> Color {
    let backgroundClassification = GarnishMath.classify(background)
    return backgroundClassification == .light ? .black : .white
}
```

---

## 🔗 Related Documentation

- **[Core API](Core-API)** - How GarnishMath powers the main Garnish functions
- **[Error Handling](Error-Handling)** - Understanding GarnishMath error cases
- **[GarnishColor](GarnishColor)** - Advanced color manipulation built on GarnishMath