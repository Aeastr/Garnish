# Garnish Refactor Changelog

This document tracks all changes made during the major refactor of the Garnish package.

## Refactor Goals

### Core API Design
- **Primary Use Case 1**: Monochromatic contrast - "I have blue, give me a shade of blue that looks good against blue"
- **Primary Use Case 2**: Bi-chromatic contrast - "I have blue and red, which version of red looks best against this blue?"

### Proposed New API Structure
```swift
// Case 1: Monochromatic - find a good shade of the same color
Garnish.contrastingShade(of: Color) -> Color

// Case 2: Bi-chromatic - optimize one color against another  
Garnish.contrastingColor(_ color: Color, against: Color) -> Color
```

### Technical Improvements
1. **Math Standardization**: Consolidate to single WCAG 2.1 relative luminance calculation
2. **Consistent Contrast Ratios**: One canonical contrast ratio implementation
3. **Clear API Boundaries**: Remove inappropriate default parameters
4. **Better Organization**: Separate public API from utility functions

### Structural Changes
- Convert Garnish from `struct` to `class`
- Expose useful utilities (luminance calculations) as public API
- Organize utilities in separate classes/namespaces
- Maintain cross-platform support (iOS/macOS)

---

## Changes Made

### 2025-08-05 - Initial Refactor Planning
- Created this changelog to track refactor progress
- Identified math inconsistencies:
  - `Garnish.brightness()` uses simple RGB averaging: `(r + g + b) / 3.0`
  - `relativeLuminance()` uses proper WCAG calculation
  - `adjustingLuminance()` uses HSB brightness manipulation
- Noted API responsibility issues (e.g., default background parameters)
- **Decision**: Offer both brightness calculation methods with luminance as default
- **Decision**: Simplify threshold parameters - eliminate separate light/dark thresholds
- **Decision**: Use standard WCAG thresholds as defaults
- **Decision**: No migration strategy needed - low current usage, users want updates ? ( i am literally the only user atp)

---

## Next Steps
- [ ] Audit current math implementations for inconsistencies
- [ ] Design clean API structure
- [ ] Implement standardized math foundation
- [ ] Refactor existing functions to use new foundation
- [ ] Update documentation and examples

---

## Breaking Changes
*To be documented as they're implemented*

## New Features
*To be documented as they're implemented*

## Bug Fixes
*To be documented as they're implemented*
