# GarnishColor

GarnishColor provides advanced color manipulation utilities for sophisticated color operations. While the Core API handles contrast generation, GarnishColor offers fine-grained control over color transformation, blending, and conversion.

## 🎨 Color Blending

### `blend(_:with:ratio:)`

Blend two colors together with precise control:

```swift
let purple = GarnishColor.blend(.red, with: .blue, ratio: 0.5)
// Returns: 50% red, 50% blue

let tintedRed = GarnishColor.blend(.red, with: .white, ratio: 0.2)  
// Returns: red with 20% white tint
```

**Parameters:**
- `color1: Color` - Base color
- `color2: Color` - Color to blend with
- `ratio: CGFloat` - Blend ratio (0.0 = 100% color1, 1.0 = 100% color2)

**Use Cases:**
- Creating color variations
- Tinting and shading
- Smooth color transitions
- Custom theme generation

---

## 🔆 Brightness Adjustment

### `adjustBrightness(of:by:)`

Adjust color brightness by percentage:

```swift
let darkerBlue = GarnishColor.adjustBrightness(of: .blue, by: -0.3)
// Returns: blue darkened by 30%

let lighterRed = GarnishColor.adjustBrightness(of: .red, by: 0.5)
// Returns: red lightened by 50%
```

**Parameters:**
- `percentage: CGFloat` - Adjustment percentage (-1.0 to 1.0)
  - Positive values: lighten
  - Negative values: darken
  - 0.0: no change

### `adjustLuminance(of:by:)`

Adjust HSB luminance with precise control:

```swift
let adjustedColor = GarnishColor.adjustLuminance(of: .blue, by: 1.5)
// Returns: blue with 50% increased luminance

let dimmedColor = GarnishColor.adjustLuminance(of: .red, by: 0.7)
// Returns: red with 30% reduced luminance
```

**Parameters:**
- `factor: CGFloat` - Luminance multiplier
  - `1.0`: no change
  - `>1.0`: brighter
  - `<1.0`: darker

**Difference from `adjustBrightness`:**
- `adjustBrightness`: Multiplies RGB components directly
- `adjustLuminance`: Works in HSB space, preserving hue and saturation

---

## 🔄 Color Conversion

### `toHex(_:includeAlpha:)`

Convert colors to hexadecimal strings:

```swift
let redHex = GarnishColor.toHex(.red)
// Returns: "FF0000"

let blueWithAlpha = GarnishColor.toHex(.blue, includeAlpha: true)
// Returns: "0000FFFF"
```

**Parameters:**
- `includeAlpha: Bool` - Whether to include alpha channel (default: false)

**Output Formats:**
- Without alpha: `"RRGGBB"` (6 characters)
- With alpha: `"RRGGBBAA"` (8 characters)

### `fromHex(_:)`

Create colors from hexadecimal strings:

```swift
let red = GarnishColor.fromHex("FF0000")
let redWithHash = GarnishColor.fromHex("#FF0000")
let shortRed = GarnishColor.fromHex("F00")        // 3-character format
let redWithAlpha = GarnishColor.fromHex("FF0000FF") // 8-character format
```

**Supported Formats:**
- `"RGB"` - 3 characters (e.g., "F00")
- `"RRGGBB"` - 6 characters (e.g., "FF0000")  
- `"RRGGBBAA"` - 8 characters (e.g., "FF0000FF")
- Optional `#` prefix supported
- Case insensitive

**Returns:** `Color?` (nil if invalid format)

---

## 🛠️ Practical Examples

### Creating Color Palettes
```swift
func generatePalette(from baseColor: Color) -> [Color] {
    return [
        ! GarnishColor.adjustLuminance(of: baseColor, by: 1.4),  // Lighter
        ! GarnishColor.adjustLuminance(of: baseColor, by: 1.2),
        baseColor,                                                  // Original
        ! GarnishColor.adjustLuminance(of: baseColor, by: 0.8),
        ! GarnishColor.adjustLuminance(of: baseColor, by: 0.6)   // Darker
    ]
}
```

### Dynamic Theme Colors  
```swift
func createThemeVariations(primary: Color) -> (light: Color, dark: Color) {
    let lightTheme = ! GarnishColor.adjustBrightness(of: primary, by: 0.3)
    let darkTheme = ! GarnishColor.adjustBrightness(of: primary, by: -0.4)
    return (lightTheme, darkTheme)
}
```

### Color Transitions
```swift
func colorGradient(from start: Color, to end: Color, steps: Int) -> [Color] {
    return (0..<steps).map { step in
        let ratio = CGFloat(step) / CGFloat(steps - 1)
        return GarnishColor.blend(start, with: end, ratio: ratio)
    }
}
```

### Hex Color Management
```swift
struct ColorManager {
    static func saveColor(_ color: Color, key: String) {
        let hex = GarnishColor.toHex(color, includeAlpha: true)
        UserDefaults.standard.set(hex, forKey: key)
    }
    
    static func loadColor(key: String) -> Color? {
        guard let hex = UserDefaults.standard.string(forKey: key) else { return nil }
        return GarnishColor.fromHex(hex)
    }
}
```

### Smart Color Adjustments
```swift
func createHoverState(for buttonColor: Color) -> Color {
    // Lighten dark colors, darken light colors
    let classification = GarnishMath.classify(buttonColor)
    let adjustment: CGFloat = classification == .light ? -0.1 : 0.1
    return GarnishColor.adjustBrightness(of: buttonColor, by: adjustment)
}
```

---

## 🔧 Technical Details

### Platform Compatibility

GarnishColor handles platform differences automatically:

```swift
#if canImport(UIKit)
// Uses UIColor for iOS/tvOS/visionOS
#elseif os(macOS) 
// Uses NSColor with proper RGB color space handling
#endif
```

### Color Space Handling

- **iOS/tvOS/visionOS**: Uses `UIColor.getRed(_:green:blue:alpha:)`
- **macOS**: Converts to `deviceRGB` color space before processing
- Ensures consistent results across platforms

### Error Handling

Functions that can fail throw specific errors:

```swift
do {
    let hex = GarnishColor.toHex(someColor)
} catch GarnishError.colorComponentExtractionFailed(let color) {
    // Handle extraction failure
} catch GarnishError.colorSpaceConversionFailed(let color, let space) {
    // Handle color space conversion failure
}
```

---

## ⚡ Performance Considerations

- **Blending**: Fast, direct RGB manipulation
- **Brightness Adjustment**: Lightweight RGB multiplication
- **Luminance Adjustment**: Involves HSB conversion (slightly slower)
- **Hex Conversion**: Minimal overhead, safe for frequent use

### Optimization Tips

```swift
// ✅ Efficient: Reuse computed values
let baseColor = Color.blue
let variations = [
    GarnishColor.blend(baseColor, with: .white, ratio: 0.1),
    GarnishColor.blend(baseColor, with: .white, ratio: 0.2),
    GarnishColor.blend(baseColor, with: .white, ratio: 0.3)
]

// ❌ Less efficient: Repeated color creation
let variations = [
    GarnishColor.blend(Color.blue, with: .white, ratio: 0.1),
    GarnishColor.blend(Color.blue, with: .white, ratio: 0.2),
    GarnishColor.blend(Color.blue, with: .white, ratio: 0.3)
]
```

---

## 🔗 Related Documentation

- **[Core API](Core-API)** - Main Garnish functions that use GarnishColor internally
- **[GarnishMath](GarnishMath)** - Mathematical foundation for color operations
- **[Error Handling](Error-Handling)** - Comprehensive error handling strategies