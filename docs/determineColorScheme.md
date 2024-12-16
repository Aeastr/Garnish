# `determineColorScheme`

Determines whether a color is a light or dark color scheme based on its relative luminance.

## Parameters
- **`color`**: The input color to evaluate.

## Example
```swift
let scheme = Garnish.determineColorScheme(.blue)
// Output: .dark
```
## Returns
A ColorScheme (.light or .dark)
