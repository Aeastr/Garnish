# Getting Started

Get up and running with Garnish in minutes. This guide covers installation, basic setup, and your first color operations.

## 📦 Installation

### Swift Package Manager

Add Garnish to your project using Xcode:

1. **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/Aeastr/Garnish`
3. Choose your version requirements
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/Garnish", from: "0.0.1")
]
```

### Platform Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS | 14.0+ |
| macOS | 13.3+ |
| tvOS | 14.0+ |
| watchOS | 7.0+ |
| visionOS | 1.0+ |

**Swift Version:** 5.9+

---

## 🚀 Quick Start

### Import Garnish

```swift
import SwiftUI
import Garnish
```

### Your First Color Operation

```swift
struct ContentView: View {
    let backgroundColor = Color.blue
    
    var body: some View {
        VStack {
            Text("Hello, Garnish!")
                .foregroundColor(contrastingTextColor)
                .padding()
                .background(backgroundColor)
        }
    }
    
    private var contrastingTextColor: Color {
        // Generate accessible text color for any background
        return Garnish.contrastingColor(.primary, against: backgroundColor) ?? .primary
    }
}
```

That's it! You now have WCAG-compliant text that automatically adjusts for any background color.

---

## 🎯 Core Concepts

### The Two Main Functions

Garnish solves color contrast with just two core functions:

**1. Monochromatic Contrast** - "Give me a better shade of the same color"
```swift
let contrastingBlue = Garnish.contrastingShade(of: .blue)
// Returns Color? - use nil-coalescing for fallbacks
```

**2. Bi-chromatic Optimization** - "Make this color work better against that background"
```swift
let readableText = Garnish.contrastingColor(.black, against: backgroundColor)
// Returns Color? - simple and clean
```

### Handling Optionals

Garnish functions return optionals instead of throwing errors:

```swift
// ✅ Simple approach with fallback
let safeColor = Garnish.contrastingShade(of: userColor) ?? .primary

// ✅ If-let when you need the value
if let optimizedColor = Garnish.contrastingColor(.red, against: .blue) {
    // Use optimizedColor
} else {
    // Handle nil case
    print("Color optimization unavailable")
}
```

---

## 🏗️ Basic Examples

### Dynamic Theme Support

```swift
struct ThemedButton: View {
    let title: String
    let baseColor: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(title) {
            // Button action
        }
        .foregroundColor(textColor)
        .background(backgroundColor)
        .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        // Adjust base color for current theme
        let adjustment: CGFloat = colorScheme == .dark ? -0.2 : 0.1
        return GarnishColor.adjustBrightness(of: baseColor, by: adjustment) ?? baseColor
    }

    private var textColor: Color {
        // Ensure text is always readable
        return Garnish.contrastingColor(.primary, against: backgroundColor) ?? .primary
    }
}
```

### Accessibility Validation

```swift
struct AccessibilityChecker: View {
    @State private var foregroundColor = Color.black
    @State private var backgroundColor = Color.white
    @State private var contrastRatio: CGFloat = 21.0
    @State private var isAccessible = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Color selection UI here...
            
            Text("Sample Text")
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .padding()
            
            VStack {
                Text("Contrast Ratio: \(String(format: "%.1f", contrastRatio)):1")
                Text(accessibilityStatus)
                    .foregroundColor(isAccessible ? .green : .red)
            }
        }
        .onChange(of: foregroundColor) { _ in updateContrast() }
        .onChange(of: backgroundColor) { _ in updateContrast() }
    }
    
    private func updateContrast() {
        contrastRatio = GarnishMath.contrastRatio(between: foregroundColor, and: backgroundColor) ?? 1.0
        isAccessible = GarnishMath.meetsWCAGAA(foregroundColor, backgroundColor)
    }

    private var accessibilityStatus: String {
        if GarnishMath.meetsWCAGAAA(foregroundColor, backgroundColor) {
            return "✅ Excellent (AAA)"
        } else if GarnishMath.meetsWCAGAA(foregroundColor, backgroundColor) {
            return "✅ Good (AA)"
        } else {
            return "❌ Poor"
        }
    }
}
```

### Color Palette Generation

```swift
struct ColorPalette: View {
    let baseColor: Color
    
    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Rectangle()
                    .fill(paletteColors[index])
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("\\(index + 1)")
                            .foregroundColor(textColor(for: paletteColors[index]))
                    )
            }
        }
    }
    
    private var paletteColors: [Color] {
        let adjustments: [CGFloat] = [1.4, 1.2, 1.0, 0.8, 0.6]
        return adjustments.compactMap { adjustment in
            GarnishColor.adjustLuminance(of: baseColor, by: adjustment)
        }
    }

    private func textColor(for background: Color) -> Color {
        return Garnish.contrastingColor(.primary, against: background) ?? .primary
    }
}
```

---

## 🛠️ Advanced Configuration

### Custom Contrast Targets

```swift
// WCAG AA (default): 4.5:1
let aaCompliant = Garnish.contrastingColor(.red, against: .blue)

// WCAG AAA: 7:1 (higher standard)
let aaaCompliant = Garnish.contrastingColor(
    .red,
    against: .blue,
    targetRatio: GarnishMath.wcagAAAThreshold
)

// Custom ratio
let customRatio = Garnish.contrastingColor(.red, against: .blue, targetRatio: 6.0)
```

### Brightness Calculation Methods

```swift
// WCAG luminance (recommended for accessibility)
let shade1 = Garnish.contrastingShade(of: .blue, using: .luminance)

// Simple RGB averaging (faster, less accurate)
let shade2 = Garnish.contrastingShade(of: .blue, using: .rgb)
```

---

## 🎮 Try the Demo App

Garnish includes a comprehensive demo app that showcases all features:

1. Open the Garnish workspace in Xcode
2. Select the `GarnishPlayground` target
3. Run the app
4. Explore the tabs!

---

## 🔍 Common Patterns

### SwiftUI Integration

```swift
extension View {
    func adaptiveBackground(_ color: Color) -> some View {
        self.background(color)
            .foregroundColor(
                Garnish.contrastingColor(.primary, against: color) ?? .primary
            )
    }
}

// Usage
Text("Adaptive Text")
    .adaptiveBackground(.blue)
```

### UIKit Integration

```swift
extension UILabel {
    func setAdaptiveText(_ text: String, on backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor

        let swiftUIBackground = Color(backgroundColor)
        if let textColor = Garnish.contrastingColor(.label, against: swiftUIBackground) {
            self.textColor = UIColor(textColor)
        }
    }
}
```

---

## Next Steps

Now that you're set up, explore the detailed documentation:

- **[Core API](Core-API.md)** - Deep dive into the main functions
- **[GarnishMath](GarnishMath.md)** - Understanding the mathematics
- **[GarnishColor](GarnishColor.md)** - Advanced color manipulation
- **[Error Handling](Error-Handling.md)** - Robust error management

---

## 💡 Tips for Success

1. **Always provide fallbacks** - Use `??` with sensible default colors
2. **Test with real content** - Colors behave differently with actual UI elements
3. **Consider your users** - Test accessibility with real accessibility tools
4. **Use the demo app** - It's the best way to understand Garnish capabilities
5. **Start simple** - Begin with the core functions before exploring advanced features

Ready to make your app more accessible and visually appealing? Let's go! 🚀