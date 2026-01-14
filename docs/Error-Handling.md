# Error Handling

Garnish uses a simple, optional-based API that eliminates the need for `try`/`catch` blocks. Functions that might fail return `nil` instead of throwing errors, making the API clean and easy to use.

## 🎯 The Optional Approach

All Garnish functions that could potentially fail return optional values:

```swift
// Returns Color? instead of throwing
let shade = Garnish.contrastingShade(of: .blue)

// Returns CGFloat? instead of throwing
let luminance = GarnishMath.relativeLuminance(of: .blue)

// Returns String? instead of throwing
let hex = GarnishColor.toHex(.blue)
```

---

## ✨ Clean, Simple Usage

### With Nil-Coalescing Operator

The most common pattern - provide a fallback:

```swift
// Simple and clean
let contrastingColor = Garnish.contrastingShade(of: userColor) ?? .primary

// With custom fallback
let hex = GarnishColor.toHex(myColor) ?? "000000"

// Chaining with multiple fallbacks
let textColor = Garnish.contrastingColor(.black, against: background)
    ?? Garnish.contrastingShade(of: background)
    ?? .white
```

### With If-Let

When you need to handle the failure case:

```swift
if let contrasted = Garnish.contrastingShade(of: userColor) {
    // Use the contrasted color
    applyTheme(contrasted)
} else {
    // Handle the nil case
    showColorError()
}
```

### With Guard

For early returns:

```swift
func updateColors() {
    guard let optimized = Garnish.contrastingColor(.red, against: background) else {
        // Handle failure and return
        useDefaultColors()
        return
    }

    // Use optimized color
    applyColors(optimized)
}
```

---

## 🔍 Debugging with Chronicle

While the API doesn't throw errors, Garnish internally logs failures using [Chronicle](https://github.com/Aeastr/Chronicle) for debugging purposes.

### Viewing Logs

Errors are logged at the `.error` level with detailed context:

```swift
// This will log internally if it fails, but returns nil to you
let color = Garnish.contrastingShade(of: problematicColor)

// Console output (if Chronicle is configured):
// [Garnish] Failed to calculate contrast ratio: <details>
```

### Configuring Chronicle (Optional)

If you want to see Garnish's internal logs:

```swift
import Chronicle

// At app launch
Logger.shared.subsystem = "com.myapp"
Logger.shared.setAllowedLevels([.debug, .info, .error])

// Now you'll see Garnish errors in Console.app or Xcode console
```

---

## 🛡️ Defensive Programming Patterns

### Pattern 1: Graceful Degradation

```swift
func createContrastingText(for background: Color) -> Color {
    // Try optimized approach first
    if let optimized = Garnish.contrastingColor(.primary, against: background) {
        return optimized
    }

    // Fallback to classification-based approach
    if let classification = GarnishMath.classify(background) {
        return classification == .light ? .black : .white
    }

    // Ultimate fallback
    return .primary
}
```

### Pattern 2: Multiple Fallbacks

```swift
func getBrightness(of color: Color) -> CGFloat {
    // Try WCAG luminance first
    if let luminance = GarnishMath.relativeLuminance(of: color) {
        return luminance
    }

    // Fallback to RGB brightness
    if let rgbBrightness = GarnishMath.rgbBrightness(of: color) {
        return rgbBrightness
    }

    // Ultimate fallback
    return 0.5
}
```

### Pattern 3: Chaining Operations

```swift
func createThemePalette(from baseColor: Color) -> [Color] {
    let adjustments: [CGFloat] = [1.4, 1.2, 1.0, 0.8, 0.6]

    return adjustments.compactMap { adjustment in
        GarnishColor.adjustLuminance(of: baseColor, by: adjustment)
    }
    // compactMap automatically filters out nil values
}
```

---

## 🧪 Testing Optional Returns

### Unit Testing

```swift
func testColorOperations() {
    // Test successful cases
    let blue = Color.blue
    XCTAssertNotNil(Garnish.contrastingShade(of: blue))
    XCTAssertNotNil(GarnishMath.relativeLuminance(of: blue))

    // Test with edge cases
    let clear = Color.clear
    // Should handle gracefully (may return nil)
    let result = Garnish.contrastingShade(of: clear)
    // Can still test behavior
}
```

### Fallback Behavior Testing

```swift
func testGracefulDegradation() {
    let backgrounds = [Color.red, Color.blue, Color.clear, Color.primary]

    for background in backgrounds {
        let result = createContrastingText(for: background)
        XCTAssertNotNil(result, "Should always return a valid color")

        // Verify reasonable behavior
        if let ratio = GarnishMath.contrastRatio(between: result, and: background) {
            XCTAssertGreaterThan(ratio, 1.0)
        }
    }
}
```

---

## 📋 Best Practices

### 1. Always Provide Fallbacks

```swift
// ✅ Good - always has a value
let color = Garnish.contrastingShade(of: userColor) ?? .primary

// ❌ Avoid - could crash if nil
let color = Garnish.contrastingShade(of: userColor)!
```

### 2. Use compactMap for Collections

```swift
// ✅ Filters out nil values automatically
let colors = baseColors.compactMap { color in
    Garnish.contrastingShade(of: color)
}

// ❌ Could contain nils
let colors = baseColors.map { color in
    Garnish.contrastingShade(of: color)
}
```

### 3. Consider User Experience

```swift
struct ColorPicker: View {
    @State private var selectedColor = Color.blue
    @State private var showError = false

    var displayColor: Color {
        Garnish.contrastingShade(of: selectedColor) ?? {
            showError = true
            return selectedColor
        }()
    }

    var body: some View {
        VStack {
            ColorSlider(color: $selectedColor)

            if showError {
                Text("Using original color (optimization unavailable)")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
        }
    }
}
```

---

## 🔗 Related Documentation

- **[Core API](Core-API)** - Understanding return types
- **[GarnishMath](GarnishMath)** - Mathematical operations
- **[GarnishColor](GarnishColor)** - Color manipulation
- **[Chronicle](https://github.com/Aeastr/Chronicle)** - Internal logging system
