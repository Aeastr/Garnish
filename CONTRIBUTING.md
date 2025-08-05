# Contributing to Garnish

Thank you for your interest in contributing to Garnish! This guide outlines the design principles, architectural decisions, and contribution standards that maintain the package's focus and quality.

## 🎯 Core Philosophy

### The Central Question
Garnish exists to answer one fundamental question:
> **"I have this color, what color should I display against it?"**

Everything in this package should serve this core purpose. If a feature doesn't directly answer this question, it likely doesn't belong in Garnish.

### Primary Use Cases
1. **Monochromatic Contrast**: "I have blue, give me a shade of blue that looks good against blue"
2. **Bi-chromatic Contrast**: "I have blue and red, which version of red looks best against this blue?"

## 🚫 Responsibility Boundaries

### What Garnish SHOULD Do
- ✅ Calculate optimal colors for contrast
- ✅ Provide WCAG-compliant accessibility measurements
- ✅ Offer mathematical color utilities (luminance, brightness, contrast ratios)
- ✅ Return color values for developers to use

### What Garnish SHOULD NOT Do
- ❌ Apply colors to UI elements automatically
- ❌ Make styling decisions for developers
- ❌ Provide SwiftUI modifiers that control layout/appearance
- ❌ Assume default values for user-specific contexts (like background colors)
- ❌ Take responsibility for UI implementation details

### The Golden Rule
**Garnish calculates, developers apply.** 

Garnish should provide the "what" (which color to use), but never the "how" (how to apply it to UI).

## 🏗️ Architecture Principles

### API Design
1. **Focused Core Classes**
   - `Garnish`: Main class for the two primary use cases
   - `GarnishMath`: Utility functions for color mathematics
   - `GarnishColor`: Color manipulation utilities

2. **Extensions for Convenience**
   - Extensions on `Color` and platform colors for convenience methods
   - Extensions should delegate to core classes, not contain complex logic
   - Single-purpose extensions are preferred over monolithic ones

3. **Clear Naming Conventions**
   - Method names should clearly indicate what they calculate
   - Avoid ambiguous terms like "adjust" or "fix"
   - Use descriptive parameters: `contrastingShade(of: color)` not `adjust(color)`

### Error Handling
- **Explicit over Silent**: Throw errors instead of returning defaults
- **No Silent Fallbacks**: If something can't be calculated, fail explicitly
- **Meaningful Errors**: Use `GarnishError` with descriptive messages

### Mathematical Standards
- **WCAG 2.1 Compliance**: All contrast calculations must follow WCAG standards
- **Single Source of Truth**: One canonical implementation for each calculation
- **Consistent Algorithms**: Use the same luminance/brightness calculations throughout

## 📁 File Organization

### Current Structure
```
Sources/Garnish/
├── Garnish.swift              # Main class with core use cases
├── GarnishMath.swift          # Mathematical utilities
├── GarnishColor.swift         # Color manipulation utilities
├── GarnishError.swift         # Error definitions
├── Extensions/                # Convenience extensions
│   ├── ColorExtensions.swift
│   ├── UIColorExtensions.swift
│   ├── ColorConvenienceExtensions.swift
│   └── FontExtensions.swift
└── Deprecated/                # Legacy APIs with migration paths
    ├── README.md
    └── [deprecated files]
```

### Organization Principles
- **Separation of Concerns**: Each file has a single, clear purpose
- **Logical Grouping**: Related functionality stays together
- **Clear Boundaries**: Public API separate from internal utilities

## 🔄 Deprecation Strategy

### When to Deprecate
- Functions that violate responsibility boundaries
- APIs that encourage misuse of the package
- Methods that assume user context (like default backgrounds)
- Features that drift from the core purpose

### How to Deprecate
1. **Move to `Deprecated/` folder**
2. **Add `@available(*, deprecated)` attribute**
3. **Provide clear migration path with before/after examples**
4. **Explain WHY it was deprecated**
5. **Update changelog with reasoning**

### Migration Paths
Always provide concrete examples:
```swift
// ❌ Old way (deprecated):
Text("Hello").garnish(.blue, on: .all)

// ✅ New way:
let contrastingColor = Garnish.contrastingShade(of: .blue)
Text("Hello").foregroundColor(contrastingColor).background(.blue)
```

## 🧪 Testing Guidelines

### What to Test
- All public API methods
- Error conditions and edge cases
- Cross-platform compatibility
- WCAG compliance of calculations
- Deprecated API migration paths

### What NOT to Test
- Internal implementation details
- UI application of colors (that's the user's responsibility)
- Specific color values (focus on relationships and ratios)

## 📝 Documentation Standards

### Code Documentation
- Every public method must have comprehensive documentation
- Include parameter descriptions and return value explanations
- Provide usage examples for complex methods
- Document error conditions

### README and Guides
- Focus on the core use cases
- Provide clear, practical examples
- Explain the philosophy behind design decisions
- Include migration guides for major changes

## 🚀 Contribution Process

### Before Contributing
1. **Understand the Core Purpose**: Does your contribution serve the fundamental question?
2. **Check Responsibility Boundaries**: Are you calculating colors or applying them?
3. **Review Existing APIs**: Is there already a way to achieve this?
4. **Consider Alternatives**: Could this be better served by an extension or separate package?

### Proposing New Features
1. **Start with the Use Case**: What specific color calculation problem does this solve?
2. **Justify the Addition**: Why does this belong in Garnish vs. user code?
3. **Design the API**: How does it fit with existing patterns?
4. **Consider Maintenance**: Will this create ongoing complexity?

### Code Review Checklist
- [ ] Does this serve the core purpose?
- [ ] Does it respect responsibility boundaries?
- [ ] Is the API clear and well-documented?
- [ ] Are errors handled explicitly?
- [ ] Is it tested appropriately?
- [ ] Does it follow naming conventions?

## ⚠️ Common Pitfalls

### Feature Creep
- **Problem**: Adding features because they're "related to colors"
- **Solution**: Always ask "Does this answer the core question?"

### Responsibility Overreach
- **Problem**: Making UI decisions for developers
- **Solution**: Provide calculations, let developers apply them

### Silent Failures
- **Problem**: Returning default values when calculations fail
- **Solution**: Throw explicit errors with helpful messages

### Inconsistent Math
- **Problem**: Multiple implementations of the same calculation
- **Solution**: Single source of truth in `GarnishMath`

## 📞 Getting Help

If you're unsure whether a contribution fits Garnish's philosophy:
1. Open an issue describing the use case
2. Explain how it serves the core purpose
3. Discuss the API design before implementation
4. Consider if it belongs in a separate package

## 🎉 Recognition

Contributors who help maintain Garnish's focused design and clear boundaries are especially valued. Quality over quantity - a small, focused contribution that respects the package's philosophy is more valuable than a large feature that creates scope creep.

---

## 💙 Thank You

Thanks for taking the time to understand Garnish's philosophy and for helping keep it focused on its core purpose. Your thoughtful contributions make a difference!

Happy coding! 🎨

---

*Remember: Garnish is a tool for color calculations, not a UI framework. Keep it focused, keep it clear, and keep it useful for its core purpose.*
