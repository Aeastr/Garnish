# `contrastingForeground`

Produces a foreground color with sufficient contrast for readability against a given background color.

- If the background color is light, a tinted dark color is returned.
- If the background color is dark, a tinted light color is returned.

## Parameters
- **`background`**: The background color to evaluate.
- **`threshold`**: The luminance threshold for determining if the background is light or dark.
- **`blendAmount`**: The ratio to blend the foreground tint with the base color).

## Example
```swift
let foregroundColor = Garnish.contrastingForeground(
    for: .blue,
    blendAmount: 0.9
)
```
## Returns
A Color object that ensures readability against the given background.
