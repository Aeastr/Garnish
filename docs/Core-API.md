# Core API

The Garnish Core API provides two essential functions that solve the most common color contrast challenges in app development. Both functions are designed to be simple, powerful, and WCAG-compliant.

## 🎯 The Two Core Functions

### 1. `contrastingShade(of:)` - Monochromatic Contrast

**Use Case**: "I have blue, give me a shade of blue that looks good against blue"

Generate a contrasting shade of the same color - perfect for creating depth, shadows, or subtle contrasts while maintaining color harmony.

```swift
// Class method
let contrastingBlue = Garnish.contrastingShade(of: .blue)

// Convenience extension
let contrastingBlue = Color.blue.contrastingShade()

// With fallback
let safeBlue = Garnish.contrastingShade(of: .blue) ?? .blue
```

**Advanced Usage:**
```swift
let shade = Garnish.contrastingShade(
    of: .blue,
    using: .luminance,           // Brightness calculation method
    targetRatio: 4.5,            // WCAG AA compliance (4.5:1)
    direction: .auto,            // Direction preference
    minimumBlend: 0.5,           // Minimum blend intensity (50%)
    blendStyle: .strong          // Or use preset styles
)
```

**Parameters:**
- `color: Color` - The base color to create a contrasting shade from
- `method: BrightnessMethod` - Calculation method (`.luminance` or `.rgb`)
- `targetRatio: CGFloat` - Minimum contrast ratio (default: 4.5 for WCAG AA)
- `direction: ContrastDirection` - Control light/dark preference (default: `.auto`)
- `minimumBlend: CGFloat?` - Minimum blend amount (0.0-1.0)
- `blendStyle: BlendStyle?` - Preset blend intensity
- `blendRange: ClosedRange<CGFloat>?` - Full control over blend range

**Returns:** `Color?` - A contrasting shade of the input color that meets the target contrast ratio, or `nil` if processing fails

---

### 2. `contrastingColor(_:against:)` - Bi-chromatic Optimization

**Use Case**: "I have blue and red, which version of red looks best against blue?"

*Note: Blue and red is a challenging color combination for readability and accessibility in most design contexts, whilst also being.. generally considered ugly, but this function will still optimize for the best possible contrast between them.*

Optimize one color to work well against another background, ensuring accessibility compliance and visual clarity.

```swift
// Class method
let optimizedRed = Garnish.contrastingColor(.red, against: .blue)

// Convenience extension
let optimizedRed = Color.red.optimized(against: .blue)

// With fallback
let safeRed = Garnish.contrastingColor(.red, against: .blue) ?? .red
```

**Advanced Usage:**
```swift
let optimized = Garnish.contrastingColor(
    .red,
    against: .blue,
    using: .luminance,           // Brightness calculation method
    targetRatio: 4.5,            // WCAG AA compliance (4.5:1)
    direction: .preferLight,     // Prefer lighter shades
    minimumBlend: 0.7            // Ensure strong contrast (70%+)
)
```

**Parameters:**
- `color: Color` - The color to optimize
- `background: Color` - The background color to optimize against
- `method: BrightnessMethod` - Calculation method (`.luminance` or `.rgb`)
- `targetRatio: CGFloat` - Minimum contrast ratio (default: 4.5 for WCAG AA)
- `direction: ContrastDirection` - Control light/dark preference (default: `.auto`)
- `minimumBlend: CGFloat?` - Minimum blend amount (0.0-1.0)
- `blendStyle: BlendStyle?` - Preset blend intensity
- `blendRange: ClosedRange<CGFloat>?` - Full control over blend range

**Returns:** `Color?` - Optimized version of the input color that meets the target contrast ratio, or `nil` if processing fails

---

## 🎛️ Direction Control

Control whether colors go lighter or darker with the `ContrastDirection` enum:

### `.auto` (Default)
Automatically picks the direction that gives the best contrast.

```swift
let shade = Garnish.contrastingShade(of: .blue, direction: .auto)
```

### `.forceLight` / `.forceDark`
Always goes in the specified direction, regardless of results. Perfect for shadows and highlights.

```swift
// Always darker - perfect for shadows
let shadow = Garnish.contrastingShade(of: .blue, direction: .forceDark)

// Always lighter - perfect for highlights
let highlight = Garnish.contrastingShade(of: .blue, direction: .forceLight)
```

### `.preferLight` / `.preferDark`
Tries the preferred direction first, only switches if it's impossible to meet the target contrast.

```swift
// Prefer white text, but use black if white can't reach target
let text = Garnish.contrastingColor(
    .white,
    against: backgroundColor,
    direction: .preferLight
)
```

**When to use each:**
- **`.auto`** - Default, most balanced results
- **`.force*`** - Visual effects (shadows/highlights) where contrast is secondary
- **`.prefer*`** - When you have aesthetic preferences but still need accessibility

---

## 🎨 Blend Intensity Control

Control how strongly colors blend towards white or black. This is useful when you want vivid contrasts instead of minimal adjustments.

### `BlendStyle` Presets

Quick presets for common use cases:

```swift
// Just enough to meet target (0%)
let minimal = Garnish.contrastingShade(of: .blue, blendStyle: .minimal)

// Moderate intensity (50% minimum)
let moderate = Garnish.contrastingShade(of: .blue, blendStyle: .moderate)

// Strong, vivid contrast (70% minimum)
let strong = Garnish.contrastingShade(of: .blue, blendStyle: .strong)

// Pure white or black (100%)
let maximum = Garnish.contrastingShade(of: .blue, blendStyle: .maximum)
```

### Custom Minimum Blend

Fine-tune the blend amount with `minimumBlend`:

```swift
// At least 60% blend towards white/black
let color = Garnish.contrastingColor(
    .red,
    against: .blue,
    targetRatio: 3.0,      // Low threshold picks direction easily
    minimumBlend: 0.6      // But blend strongly for vivid result
)
```

### Full Range Control

Complete control with `blendRange`:

```swift
// Search between 40% and 80% blend only
let color = Garnish.contrastingColor(
    .red,
    against: .blue,
    blendRange: 0.4...0.8
)
```

**Common Pattern:**
Lower the `targetRatio` to influence direction choice, then use `minimumBlend` to ensure vivid colors:

```swift
// "I want white text, but strong white, not wimpy white"
let whiteText = Garnish.contrastingColor(
    .white,
    against: backgroundColor,
    targetRatio: 3.0,        // Low threshold = easily picks white
    minimumBlend: 0.7        // But blends strongly = vivid white
)
```

---

## 🎨 SwiftUI-Style Extensions

Both core functions are available as convenient Color extensions for a more natural, SwiftUI-like syntax:

```swift
// Instead of: Garnish.contrastingShade(of: color)
let shade = color.contrastingShade() ?? color

// Instead of: Garnish.contrastingColor(color, against: background)
let optimized = color.optimized(against: background) ?? color
```

**Benefits of Extensions:**
- More readable, fluent API
- Follows SwiftUI naming conventions
- Better IDE autocomplete experience
- Method chaining friendly

---

## 🔍 Quick Accessibility Check

### `hasGoodContrast(_:_:)`

Quick validation for accessibility compliance:

```swift
let isAccessible = Garnish.hasGoodContrast(.white, .black)
// Returns: true (meets WCAG AA standards)

let needsImprovement = Garnish.hasGoodContrast(.lightGray, .white)
// Returns: false (insufficient contrast)
```

---

## 🎨 Practical Examples

### Text on Colored Backgrounds
```swift
let backgroundColor = Color.blue
let textColor = Garnish.contrastingColor(.black, against: backgroundColor)
// Returns optimized text color for accessibility
```

### Button with Preference for White Text
```swift
let buttonColor = Color.green
let textColor = Garnish.contrastingColor(
    .white,
    against: buttonColor,
    direction: .preferLight,  // Try white first
    minimumBlend: 0.7         // Ensure vivid white if possible
)
```

### Shadow and Highlight Effects
```swift
let primaryColor = Color.blue

// Shadow (always darker)
let shadow = Garnish.contrastingShade(
    of: primaryColor,
    direction: .forceDark,
    blendStyle: .moderate
)

// Highlight (always lighter)
let highlight = Garnish.contrastingShade(
    of: primaryColor,
    direction: .forceLight,
    blendStyle: .strong
)
```

### Dynamic Theme Support
```swift
@Environment(\.colorScheme) var colorScheme

var adaptiveTextColor: Color {
    let background = colorScheme == .dark ? Color.black : Color.white
    return Garnish.contrastingColor(.primary, against: background) ?? .primary
}
```

---

## ⚡ Performance & Error Handling

- **Fast**: Calculations are optimized for real-time use
- **Safe**: All functions return optionals and handle edge cases gracefully
- **Predictable**: Consistent results across all Apple platforms
- **Debuggable**: Internal errors logged via Chronicle for debugging

See **[Error Handling](Error-Handling.md)** for best practices with optional returns.

---

## Related Documentation

- **[GarnishMath](GarnishMath.md)** - Understanding the calculations behind these functions
- **[Getting Started](Getting-Started.md)** - Installation and setup guide
- **[GarnishColor](GarnishColor.md)** - Advanced color manipulation utilities
