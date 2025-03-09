# `adjustForBackground`

Produces a background color dynamically adjusted based on the input color's brightness and the provided color scheme (light or dark).

- If the input color is not excessively light or dark, it is blended using a subtle ratio (`lightBlendRatio` or `darkBlendRatio`).
- If the input color is very light or very dark, it is blended more heavily using `blendAmount`.

## Parameters
- **`color`**: The input color to evaluate and adjust.
- **`scheme`**: The color scheme (`.light` or `.dark`) that determines the adjustment logic.
- **`blendAmount`**: The primary ratio to blend the input color with the base color when adjustments are necessary.
- **`lightBlendRatio`**: The ratio to blend when the input color is not excessively bright in a light scheme.
- **`darkBlendRatio`**: The ratio to blend when the input color is not excessively dark in a dark scheme.

## Example
```swift
let backgroundColor = Garnish.adjustForBackground(
    for: .blue,
    in: .light
)
```
### Returns
A Color object that is either the input color or adjusted to ensure better contrast based on the color scheme.
