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

### 20:00 - Initial Refactor Planning
- Created this changelog to track refactor progress
- Identified math inconsistencies:
  - `Garnish.brightness()` uses simple RGB averaging: `(r + g + b) / 3.0`
  - `relativeLuminance()` uses proper WCAG calculation
  - `adjustingLuminance()` uses HSB brightness manipulation
- Noted API responsibility issues (e.g., default background parameters)
- **Decision**: Offer both brightness calculation methods with luminance as default
- **Decision**: Simplify threshold parameters - eliminate separate light/dark thresholds
- **Decision**: Use standard WCAG thresholds as defaults
- **Decision**: No migration strategy needed - low current usage, users want updates

### 20:05 - Function Audit Complete
**Existing Functions Categorized:**

** Core Use Case 1 (Monochromatic - same color, different shade):**
- `contrastingForeground()` - Takes background color, returns contrasting version of same color **(DEPRECATED)**
- `colorBase()` - DEPRECATED/COMMENTED OUT - was for blending with base colors **(REMOVE)**

** Core Use Case 2 (Bi-chromatic - two different colors):**
- `adjustForBackground()` - Takes color + background, adjusts color for contrast **(DEPRECATED)**

** Utility Functions Review:**
- `relativeLuminance()` - WCAG compliant luminance calculation **(KEEP)**
- `brightness()` - Simple RGB averaging (r+g+b)/3 **(KEEP)** - useful for non-accessibility cases
- `luminanceContrastRatio()` - Contrast ratio between two colors **(RENAME to `contrastRatio`)**
- `isLightColor()` / `isDarkColor()` - Color classification **(REPLACE with enum-returning function)**
- `determineColorScheme()` - Auto-detect light/dark scheme **(KEEP, but rename to `colorScheme(for:)`)**

** UI/UX Features:**
- `recommendedFontWeight()` - Font weight based on contrast **(KEEP)** - useful feature
- `garnishModifier` - SwiftUI view modifiers **(KEEP)** - good UX feature
- Color extensions (brightness adjustment, hex conversion, etc.) **(REVIEW INDIVIDUALLY)**

** Problems Identified:**
- Multiple threshold systems (3.0, 3.5, 4.5) - need standardization
- Default parameter overreach (backgroundColor defaults)
- Inconsistent brightness calculations
- Complex parameter sets (lightBlendRatio, darkBlendRatio, etc.)

### 20:10 - Standardized Math Foundation Implemented
**New Files Created:**
- `GarnishMath.swift` - Standardized mathematical utilities
  - Single source of truth for luminance/brightness calculations
  - WCAG-compliant contrast ratio calculations
  - Unified threshold system (4.5:1 AA, 7:1 AAA)
  - Support for both luminance and RGB brightness methods
- `Garnish.swift` - Refactored main API (converted from struct to class)
  - `contrastingShade(of:)` - Monochromatic contrast (Use Case 1)
  - `contrastingColor(_:against:)` - Bi-chromatic contrast (Use Case 2) 
  - Simplified parameters, no default background overreach
  - Binary search algorithm for optimal contrast ratios
  - Delegates utility functions to GarnishMath for consistency
- `GarnishColor.swift` - Color manipulation utilities
  - Standardized blending functions
  - Brightness/luminance adjustment methods
  - Hex conversion utilities

**Key Improvements:**
✅ Eliminated multiple threshold systems - now uses single WCAG standards
✅ Removed inappropriate default parameters
✅ Consistent brightness calculation methods with user choice
✅ Clean, purpose-driven API matching the two core use cases
✅ Proper separation of concerns (math, core API, utilities)

### 20:12 - Core API Refactorions Refactored
**Functions Updated:**
- `adjustForBackground.swift` - Now deprecated, delegates to `contrastingColor(_:against:)`
  - Removed complex parameter sets (lightBlendRatio, darkBlendRatio, etc.)
  - Fixed inappropriate default parameter behavior
  - Uses WCAG AA standard thresholds
- `contrastingForeground.swift` - Now deprecated, delegates to `contrastingShade(of:)`
  - Simplified to use standardized math foundation
  - Cleaner API with consistent behavior

**Key Improvements:**
✅ Eliminated problematic default background parameters
✅ All legacy functions now use standardized GarnishMath calculations
✅ Clear deprecation warnings with migration examples
✅ Backward compatibility maintained while encouraging new API adoption

### 2025-08-05 - Function Renames and Cleanup
**Utility Functions Renamed for Clarity:**
- `luminanceContrastRatio()` → `contrastRatio()` **(RENAMED)** - cleaner, shorter name
- `determineColorScheme()` → `colorScheme(for:)` **(RENAMED)** - more intuitive naming
- `isLightColor()` / `isDarkColor()` → `classify()` **(REPLACED)** - single function returning enum

**New Enum-Based Color Classification:**
- Added `GarnishMath.ColorClassification` enum (.light, .dark)
- `classify(_:)` returns enum instead of separate boolean functions
- Cleaner API: `let classification = Garnish.classify(.blue)`

**Functions Marked for Status:**
- `relativeLuminance()` **(KEEP)** - WCAG standard
- `brightness()` **(KEEP)** - useful for non-accessibility cases  
- `recommendedFontWeight()` **(KEEP)** - useful UI feature
- `garnishModifier` **(KEEP)** - good UX feature
- `colorBase()` **(REMOVE)** - already commented out

**Key Improvements:**
✅ Eliminated redundant boolean functions in favor of enum-based classification
✅ Cleaner, more intuitive function names
✅ All legacy functions deprecated with clear migration paths
✅ Maintained backward compatibility while encouraging modern API usage

### 20:16 - Organizational Cleanup: Deprecated Functions
**Better Project Structure:**
- Created `Sources/Garnish/Deprecated/` folder for all deprecated functionality
- Moved standalone deprecated files:
  - `adjustForBackground.swift` → `Deprecated/adjustForBackground.swift`
  - `contrastingForeground.swift` → `Deprecated/contrastingForeground.swift`
  - `colorBase(dep).swift` → `Deprecated/colorBase(dep).swift`
- Created extension files for class-based deprecated methods:
  - `Deprecated/GarnishDeprecated.swift` - Main Garnish class deprecated methods
  - `Deprecated/GarnishMathDeprecated.swift` - GarnishMath class deprecated methods
- Added `Deprecated/README.md` with migration guide and timeline

**Cleaned Main Classes:**
- Removed deprecated methods from `Garnish.swift` (now in extension)
- Removed deprecated methods from `GarnishMath.swift` (now in extension)
- Main classes now contain only current, non-deprecated API

**Key Improvements:**
✅ Much cleaner project structure - deprecated code isolated
✅ Main classes are now clean and focused on current API
✅ Deprecated functions still work but are properly organized
✅ Clear migration path documented in Deprecated/README.md
✅ Eliminated the terrible "Garnish Functions" folder structure

### 20:17 - API Cleanup: Removed Unnecessary Delegation Functions
**Cleaner Main API:**
- Removed pointless one-liner delegation functions from `Garnish.swift`:
  - `relativeLuminance(of:)` → Users call `GarnishMath.relativeLuminance(of:)` directly
  - `brightness(of:)` → Users call `GarnishMath.brightness(of:)` directly
  - `classify(_:)` → Users call `GarnishMath.classify(_:)` directly
  - `colorScheme(for:)` → Users call `GarnishMath.colorScheme(for:)` directly
  - `contrastRatio(between:and:)` → Users call `GarnishMath.contrastRatio(between:and:)` directly

**Marked Legitimate Convenience Functions:**
- Added "Convenience function" comments to `GarnishMath.swift` functions that add real value:
  - `colorScheme(for:)` - Saves users from knowing about `.colorScheme` property
  - `meetsWCAGAA(_:_:)` - Saves users from remembering the 4.5 threshold

**Fixed Deprecated Extensions:**
- Updated `GarnishDeprecated.swift` to reference correct functions (`GarnishMath.*` instead of removed `Garnish.*`)
- Ensured all deprecated functions still work but point to the real implementations

**Key Improvements:**
✅ `Garnish` class now focused only on core use cases + one convenience method
✅ Clear distinction between delegation (removed) vs convenience (kept)
✅ Users call utility functions directly from `GarnishMath` where they belong
✅ Deprecated functions still work and point to correct implementations
✅ Much cleaner, more logical API structure

### 20:19 - Color Extensions Standardization
**Cleaned Up Color Extensions:**
- Refactored `Color Extensions.swift` to remove inconsistent brightness methods:
  - Removed `adjustedBrightness(by:)` with RGB multiplication logic
  - Removed `adjustedBrightness(for:by:)` with scheme-based complexity
  - Removed `adjustingLuminance(by:)` with HSB manipulation
- Replaced with clean, standardized methods that delegate to `GarnishColor`:
  - `adjustedBrightness(by:)` → calls `GarnishColor.adjustBrightness(of:by:)`
  - `adjustedLuminance(by:)` → calls `GarnishColor.adjustLuminance(of:by:)`
- Kept useful `toHex(alpha:)` function as-is
- `UI Color Extensions.swift` already clean - contains essential `blend(with:ratio:)` and `relativeLuminance()` functions

**Key Improvements:**
✅ Eliminated multiple confusing brightness calculation methods
✅ Color extensions now consistent with standardized GarnishColor utilities
✅ Clean delegation pattern - extensions are thin wrappers around core utilities
✅ Maintained useful hex conversion functionality
✅ All color manipulation now uses the same mathematical foundation

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
