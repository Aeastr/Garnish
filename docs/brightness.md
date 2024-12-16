# `brightness`

Calculates the brightness of a color using a simple RGB averaging heuristic.

## Parameters
- **`color`**: The input color to analyze.

## Example
```swift
let brightness = Garnish.brightness(of: .blue)
```
## Returns
A CGFloat value between 0.0 and 1.0 representing the brightness.
