//
//  garnishModifier.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//

import SwiftUI

/// Specifies which parts of a view should be affected by the `garnish` modifier.
public enum GarnishScope {
    /// Adjust the foreground elements of the view.
    case foreground
    /// Adjust the background elements of the view.
    case background
    /// Adjust both foreground and background elements of the view.
    case all
}

/// Describes the mode for determining contrasting colors for garnish operations.
public enum GarnishMode {
    /// Automatically determine a contrasting color for the given input color.
    case autoContrast
    /// Use a custom contrast strategy to ensure the main color contrasts well with the provided background.
    case customContrast
}

extension View {
    // MARK: - Single Color Garnish
    
    /// Applies a single color to a view and ensures that foreground elements remain visible against this color.
    ///
    /// This modifier determines the appropriate foreground color to ensure adequate contrast against the provided `color`. You can also specify which areas of the view (foreground, background, or both) should be adjusted.
    ///
    /// - Parameters:
    ///   - color: The main color to apply.
    ///   - scope: The part(s) of the view to be adjusted. Defaults to `.foreground`.
    ///
    /// - Returns: A modified view with a contrasting foreground color and optionally a background color, depending on `scope`.
    ///
    /// # Example
    /// ```swift
    /// Text("Hello, World!")
    ///     .garnish(.blue, on: .all) // Ensures blue foreground contrasts well against blue background.
    /// ```
    public func garnish(
        _ color: Color,
        on scope: GarnishScope = .all
    ) -> some View {
        self.modifier(GarnishModifierCon(color: color, scope: scope))
    }
    
    // MARK: - Foreground and Background Garnish
    
    /// Applies a foreground and background color to a view, ensuring the foreground color remains visible against the background.
    ///
    /// This modifier takes two colors: one for the foreground and one for the background. It ensures that the chosen foreground color is adjusted to have good contrast against the specified background color. The `scope` parameter lets you control which areas (foreground, background, or both) should be altered.
    ///
    /// - Parameters:
    ///   - foreground: The intended foreground color.
    ///   - background: The intended background color.
    ///   - scope: The parts of the view to adjust. Defaults to `.all`.
    ///
    /// - Returns: A view with a foreground color that contrasts appropriately with the given background, depending on `scope`.
    ///
    /// # Example
    /// ```swift
    /// Text("Welcome")
    ///     .garnish(.white, .black, on: .all) // White text on a black background with ensured contrast.
    /// ```
    public func garnish(
        _ foreground: Color,
        _ background: Color,
        on scope: GarnishScope = .all
    ) -> some View {
        self.modifier(
            GarnishModifierAFB(
                color: foreground,
                secondaryColor: background,
                scope: scope
            )
        )
    }
}

/// A modifier that applies foreground and background colors to ensure visible contrast.
struct GarnishModifierAFB: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let secondaryColor: Color
    let scope: GarnishScope

    init(color: Color, secondaryColor: Color, scope: GarnishScope) {
        self.color = color
        self.secondaryColor = secondaryColor
        self.scope = scope
    }

    func body(content: Content) -> some View {
        if scope == .all{
            content
                .foregroundColor(
                    Garnish
                        .adjustForBackground(for: color, in: colorScheme, with: secondaryColor)
                )
                .background(secondaryColor)
        }
        else if scope == .foreground{
            content
                .foregroundColor(
                    Garnish
                        .adjustForBackground(for: color, in: colorScheme, with: secondaryColor)
                )
        }
        else if scope == .background{
            content
                .background(secondaryColor)
        }
    }
}


/// A modifier that ensures a single color selection remains visible against itself.
struct GarnishModifierCon: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let scope: GarnishScope

    init(color: Color, scope: GarnishScope) {
        self.color = color
        self.scope = scope
    }

    func body(content: Content) -> some View {
        if scope == .all{
            content
                .foregroundColor(Garnish.contrastingForeground(for: color))
                .background(color)
        }
        else if scope == .foreground{
            content
                .foregroundColor(Garnish.contrastingForeground(for: color))
        }
        else if scope == .background{
            content
                .background(color)
        }
    }
}


#Preview{
    if #available(iOS 16.4, *) {
        GarnishModifierExampels()
    }
}
