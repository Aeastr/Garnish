<div align="center">
  <img width="128" height="128" src="/resources/icons/icon.png" alt="Garnish Icon">
  <h1><b>Garnish</b></h1>
  <p>
    Intelligent color utilities for accessibility, contrast optimization, and visual harmony.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?logo=swift&logoColor=white" alt="Swift 5.9+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-14+-000000?logo=apple" alt="iOS 14+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/macOS-14+-000000?logo=apple" alt="macOS 14+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/tvOS-14+-000000?logo=apple" alt="tvOS 14+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/watchOS-7+-000000?logo=apple" alt="watchOS 7+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/visionOS-1+-000000?logo=apple" alt="visionOS 1+"></a>
</p>

| ![Auto Contrast](resources/icons/autoContrast.png) | ![Color Math](resources/icons/colorMath.png) | ![Color Analysis](resources/icons/colorAnalysis.png) |
|:---:|:---:|:---:|
| **Auto Contrast** | **Color Math** | **Color Analysis** |
| Automatically generate readable text colors from any background | Calculate luminance, brightness, and contrast ratios with WCAG standards | Classify colors as light/dark and validate accessibility compliance |


## Overview

- **Contrast Optimization** - Generate colors that meet WCAG accessibility standards
- **Dynamic Color Adaptation** - Colors that work beautifully in light and dark themes
- **Mathematical Color Analysis** - Precise luminance, brightness, and contrast calculations
- **Smart Color Generation** - Create contrasting shades and optimized color combinations
- **Font Weight Optimization** - Improved readability through accessibility-first recommendations


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/Garnish.git", from: "1.0.0")
]
```

See **[Getting Started](docs/Getting-Started.md)** for detailed setup instructions.


## Usage

```swift
import Garnish

// Generate accessible text color for any background
let textColor = Garnish.contrastingColor(.primary, against: backgroundColor) ?? .primary

// Create a contrasting shade of the same color
let shade = Garnish.contrastingShade(of: .blue) ?? .blue

// Check accessibility compliance
let isAccessible = Garnish.hasGoodContrast(foreground, background)
```

See **[Documentation](docs/)** for the full API reference.


## Playground

Garnish includes a demo app to explore its features. Open the Xcode workspace, select `GarnishPlayground`, and run.

![Garnish Base Demo](resources/examples/GarnishBaseDemo.png)


## How It Works

Garnish uses WCAG 2.1 luminance calculations to determine optimal contrast ratios. The core algorithm calculates relative luminance using the sRGB color space formula, then generates contrasting colors that meet accessibility thresholds (4.5:1 for AA, 7:1 for AAA compliance).


## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.


## License

MIT. See [LICENSE](LICENSE) for details.
