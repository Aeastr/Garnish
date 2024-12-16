# UIColor Extensions

Provides additional functionality for `UIColor`, such as blending and luminance calculation.

---

## `blend`

Blends the current color with another color by a given ratio.

### Parameters
- **`other`**: The color to blend with.
- **`ratio`**: The blend ratio (`0.0` to `1.0`).

### Example
```swift
let blendedColor = UIColor.red.blend(
    with: .blue,
    ratio: 0.5
)
```
### Returns
A new UIColor object representing the blended color.

## `relativeLuminance`
Calculates the relative luminance of the current color.

### Example
```swift
let luminance = UIColor.red.relativeLuminance()
```
### Returns
A value between 0.0 and 1.0 representing the relative luminance.
