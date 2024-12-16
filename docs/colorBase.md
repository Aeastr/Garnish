# `colorBase`

Produces a version of the input color that is blended with a base color (white or black), determined by the provided color scheme.

- If the scheme is `.light`, the input color is blended towards black.
- If the scheme is `.dark`, the input color is blended towards white.

## Parameters
- **`color`**: The input color to adjust.
- **`scheme`**: The color scheme (`.light` or `.dark`) that determines the base blending behavior.
- **`blendAmount`**: The ratio to blend the input color with the base color (default: `0.90`).

## Example
```swift
let colorBase = Garnish.colorBase(
    for: .blue,
    in: .dark
)
```
## Returns
A Color object that is tinted towards the appropriate base color for the given scheme.
