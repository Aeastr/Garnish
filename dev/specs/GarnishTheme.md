This spec proposes a new feature for Garnish, **GarnishTheme**, porting a feature from Kyo's (2.0 Ava) **FlavorKit** - a package designed to enable advanced theming in apps.

### Legacy System: FlavorKit

FlavorKit worked on a basis of a 3-2 color system, with 3 main colors (`primary`, `secondary`, `tertiary`) and 2 background colors (`primary`, `secondary`).

It operated on a combination of CoreData and Presets, meaning Kyo provided its own built-in themes and allowed users to make their own, without any difference to the user (no extra UI for different sections for selecting).

While useful, this system was limited and Kyo 2.0 Ava never shipped, being scrapped and later planned to be reworked into 2.0 Ren. While perfect for Kyo, as a package feature it needed more customization. With FlavorKit, you could only have the 3 main and 2 background colors; you could not add your own or remove any. This was a limit of the data model and API. This is a core limitation and an issue going forward, something to be considered in implementation.

It provided a class `FlavorKit()` with quick access methods:
* `flavorKit.primary`
* `flavorKit.secondary`
* `flavorKit.tertiary`
* `flavorKit.backgroundPrimary`
* `flavorKit.backgroundSecondary`

The API also included methods to create a new "flavor" (an entry of colors) into CoreData and retrieve them by name.

For persistence, it held `AppStorage` within itself to remember the selected theme. Initially, it just remembered the theme name, but later it stored the raw color values directly in `AppStorage`, which is a potentially questionable approach. Other persistence methods should be explored.

---

### GarnishTheme Proposal

For **GarnishTheme**, we want it to be more dynamic and flexible, learning from the limitations of FlavorKit.

By default, we will provide a standard set of colors: `primary`, `secondary`, `tertiary`, and a single `backgroundColor`. The key difference is allowing developers to define themes with a custom set of colors.

#### Proposed API & Design Considerations

The API should be intuitive for both creating and consuming themes.

**1. Theme Creation:**

A potential creation API could look like this:
```swift
// Create a theme with default color keys
let newTheme = GarnishTheme.create("MyTheme")

// Create a theme with a specific, custom set of color keys
let customTheme = GarnishTheme.create("MyOtherTheme", with: [.primary, .secondary, .custom("accent")])
````

This approach raises several design questions:

  * **Setting Colors:** How are colors for custom keys (e.g., `"accent"`) set? If a theme is created without a `tertiary` color, should the API prevent attempts to set it? The theme itself needs to track which colors it supports.
  * **API Ergonomics:** The `with:` parameter feels explicit, which is good for safety, but might be cumbersome. We need to find a balance.

**2. Theme Fetching & Usage:**

Fetching a theme would be straightforward, but accessing custom colors presents a challenge.

```swift
let theme = GarnishTheme.fetchTheme(ofName: "MyOtherTheme")

theme.primary // Standard accessor
theme.secondary // Standard accessor

// How do we access the custom "accent" color?
theme.color(forName: "accent") // This is functional, but not as clean.
```

An ideal API would feel more direct, but solutions like `dynamicMemberLookup` have been considered and rejected. While it would allow for `theme.accent`, it offers no compile-time safety, allows any property to be called, and makes fallbacks messy. This trade-off is not acceptable. The final API must prioritize type safety and predictability.

We've considered protocols, among other approaches, we need something that feels Swift-native

---

### Alternative API Approaches

**Option 1: Post-Creation Schema Definition**
```swift
// Clean creation without schema declaration
let theme = GarnishTheme.create("MyTheme")

// Define schema through usage
theme.defineColor("accent") // Adds "accent" to schema
theme.setColor(.primary, Color.blue)
theme.setColor("accent", Color.green)

// Access throws if color not defined
let accent = try theme.color("accent") // ✅ Safe, throws if undefined
```

**Option 2: Keyed Subscript with Error Throwing**
```swift
enum ColorKey {
    case primary, secondary, tertiary, backgroundColor
    case custom(String)
}

let theme = GarnishTheme.create("MyTheme")

// Setting defines the key automatically
theme[.primary] = Color.blue
theme[.custom("accent")] = Color.green

// Access throws for undefined keys
let primary = try theme[.primary] // ✅ Safe access
let accent = try theme[.custom("accent")] // ✅ Safe access
```

**Option 3: Method Chaining Definition**
```swift
let theme = GarnishTheme.create("MyTheme")
    .withPrimary(Color.blue)
    .withSecondary(Color.red)
    .withCustom("accent", Color.green)

// Access is guaranteed safe after definition
let primary = theme.primary // ✅ No optionals needed
let accent = try theme.custom("accent") // ✅ Throws if not defined
```

**Core Design Principle:** The theme should track its own schema internally based on what colors have been set, eliminating the need for upfront schema declaration while maintaining type safety through error throwing.

---

### Persistence Strategy Considerations

FlavorKit's approach:
- **CoreData**: Persistent theme storage and management
- **AppStorage**: Current theme colors cached for immediate access (avoiding CoreData fetches on every color access)

The caching strategy raises questions:
- **Performance benefit**: Eliminates CoreData queries for `theme.primary` access
- **Sync complexity**: Must keep AppStorage cache in sync with CoreData
- **Memory concerns**: Raw color data in AppStorage could become large with many custom colors

**Alternative Caching Strategies:**

**Option 1: In-Memory Singleton Cache**
```swift
class GarnishTheme {
    private static var currentTheme: GarnishTheme?
    
    static var current: GarnishTheme {
        return currentTheme ?? loadDefaultTheme()
    }
    
    static func setCurrentTheme(_ theme: GarnishTheme) {
        currentTheme = theme
        // Store only theme name in AppStorage
        UserDefaults.standard.set(theme.name, forKey: "currentThemeName")
    }
}
```

**Option 2: Hybrid Approach (Theme Name + Color Cache)**
```swift
// Store theme name in AppStorage
@AppStorage("currentTheme") private var currentThemeName: String = "Default"

// Cache frequently accessed colors only
@AppStorage("cachedPrimary") private var cachedPrimary: String = ""
@AppStorage("cachedSecondary") private var cachedSecondary: String = ""
```

**Question:** Is the AppStorage caching worth the complexity, or would a simple in-memory cache suffice for most use cases?

---

### Implementation Considerations & Edge Cases

**Theme Validation:**
```swift
// What happens when loading a theme with missing colors?
let theme = try GarnishTheme.load("PartialTheme") // Has primary, missing secondary
let secondary = try theme.secondary // Should this throw or generate a fallback?
```

**Schema Evolution:**
- How do we handle apps that add new color requirements over time?
- Should themes auto-expand to include new standard colors?
- What about deprecated color keys?

**Custom Color Key Conflicts:**
```swift
// App defines custom "accent" color
theme.setCustom("accent", Color.blue)

// Later, Garnish adds "accent" as a standard color
// How do we handle this naming collision?
```

**Theme Inheritance/Composition:**
```swift
// Should we support theme inheritance?
let darkTheme = GarnishTheme.create("Dark")
let userDarkTheme = GarnishTheme.createFrom(darkTheme, name: "MyDark")
userDarkTheme.setColor(.primary, Color.purple) // Override one color
```

**Performance Considerations:**
- Should color access be `O(1)` or is `O(log n)` acceptable?
- How many themes should we expect apps to have? (10s, 100s, 1000s?)
- Should we lazy-load theme colors or preload everything?

**Thread Safety:**
- Multiple threads accessing/modifying themes
- SwiftUI view updates when themes change
- Atomic operations for theme switching

**Migration Strategy:**
- How do we migrate from existing theming solutions?
- Backwards compatibility with FlavorKit-style APIs
- Import/export functionality for theme sharing