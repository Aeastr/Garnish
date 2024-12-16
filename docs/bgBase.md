# `bgBase`

Produces a background color dynamically adjusted based on the input color's brightness and the provided color scheme (light or dark).

- If the input color is not excessively light or dark, it is blended using a subtle ratio (`lightBlendRatio` or `darkBlendRatio`).
- If the input color is very light or very dark, it is blended more heavily using `blendAmount`.

## Parameters
- **`color`**: The input color to evaluate and adjust.
- **`scheme`**: The color scheme (`.light` or `.dark`) that determines the adjustment logic.
- **`blendAmount`**: The primary ratio to blend the input color with the base color when adjustments are necessary (default: `0.90`).
- **`lightBlendRatio`**: The ratio to blend when the input color is not excessively bright in a light scheme (default: `0.1`).
- **`darkBlendRatio`**: The ratio to blend when the input color is not excessively dark in a dark scheme (default: `0.3`).

## Example
```swift
let backgroundColor = Garnish.bgBase(
    for: .blue,
    in: .light
)
```
