# Garnish

**Garnish** helps you pick the ideal colors for text and UI elements in light and dark themes, ensuring optimal contrast and visual harmony based on luminance and brightness.

## Features
- **Dynamic Background Colors**: Automatically adjust colors for light or dark themes with customizable blending.
- **Contrast-Optimized Foreground Colors**: Ensure text is readable against any background.
- **Color Utilities**: Access brightness, luminance, and contrast ratio calculations.
- **Blending & Manipulation**: Blend colors dynamically and adjust brightness for visual balance.

## Join the Kyo Discord

[Join the Kyo Discord](https://discord.gg/6NHhAvwbXV) to discuss features, share feedback, or connect with other users. It's a great place to collaborate and engage with the community.

---

## Getting Started

### Installation
Garnish is available as a Swift Package. Add it to your project using the following steps:

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL: `[https://github.com/Aeastr/Garnish.git]`
3. Add the package to your desired targets.

---

## Examples

### Generate a Color for typical backgrounds 
Adjust a color to create a background that adapts to the current color scheme.

```swift
let backgroundColor = Garnish.bgBase(for: .blue, in: .light)
```

### Generate a Foreground Color
Ensure text or elements are readable against a given background using `contrastingForeground`.
```swift
let foregroundColor = Garnish.contrastingForeground(for: .blue)
```

> More Examples in Docs and Demo in [Sources/Garnish/Demo.swift](Sources/Garnish/Demo.swift)

---

## Documentation Index

Explore detailed documentation for each function and extension under the [`docs/`](docs/) directory:

- [Dynamic Background Colors (`bgBase`)](docs/bgBase.md)
- [Dynamic Color Adjustment (`colorBase`)](docs/colorBase.md)
- [Contrast-Optimized Foregrounds (`contrastingForeground`)](docs/contrastingForeground.md)
- [Relative Luminance (`relativeLuminance`)](docs/relativeLuminance.md)
- [Brightness Calculation (`brightness`)](docs/brightness.md)
- [Determine Color Scheme (`determineColorScheme`)](docs/determineColorScheme.md)
- [Contrast Ratio (`contrastRatio`)](docs/contrastRatio.md)
- [UIColor Extensions (`blend`, `relativeLuminance`)](docs/UIColorExtensions.md)

---

## Contribution

We welcome contributions to enhance Garnish! Feel free to open issues or submit pull requests.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
