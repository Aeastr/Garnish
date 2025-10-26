//
//  garnishModifier.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  DEPRECATED: SwiftUI modifiers violate API responsibility boundaries
//

import SwiftUI

/// **DEPRECATED**: This enum will be removed in a future version.
/// The SwiftUI modifiers that used this enum violated API responsibility boundaries.
/// Users should control their own UI styling and use Garnish only for color calculations.
@available(*, deprecated, message: "Use Garnish color calculation methods directly and apply colors manually")
public enum GarnishScope {
    /// Adjust the foreground elements of the view.
    case foreground
    /// Adjust the background elements of the view.
    case background
    /// Adjust both foreground and background elements of the view.
    case all
}

/// **DEPRECATED**: This enum will be removed in a future version.
/// The SwiftUI modifiers that used this enum violated API responsibility boundaries.
@available(*, deprecated, message: "Use Garnish color calculation methods directly")
public enum GarnishMode {
    /// Automatically determine a contrasting color for the given input color.
    case autoContrast
    /// Use a custom contrast strategy to ensure the main color contrasts well with the provided background.
    case customContrast
}

extension View {
    // MARK: - Single Color Garnish

    /// **DEPRECATED**: This modifier will be removed in a future version.
    ///
    /// **Why Deprecated**: This modifier violates API responsibility boundaries by automatically
    /// applying UI styling decisions that should be controlled by the user.
    ///
    /// **Migration Path**: Use Garnish for color calculations only, then apply colors manually:
    /// ```swift
    /// // Old way:
    /// Text("Hello").garnish(.blue, on: .all)
    ///
    /// // New way:
    /// let contrastingColor = Garnish.contrastingShade(of: .blue)
    /// Text("Hello")
    ///     .foregroundColor(contrastingColor)
    ///     .background(.blue)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The main color to apply.
    ///   - scope: The part(s) of the view to be adjusted. Defaults to `.foreground`.
    /// - Returns: A modified view with a contrasting foreground color and optionally a background color, depending on `scope`.
    @available(*, deprecated, message: "Use Garnish.contrastingShade(of:) and apply colors manually")
    public func garnish(
        _ color: Color,
        on scope: GarnishScope = .all
    ) -> some View {
        self.modifier(GarnishModifierCon(color: color, scope: scope))
    }

    // MARK: - Foreground and Background Garnish

    /// **DEPRECATED**: This modifier will be removed in a future version.
    ///
    /// **Why Deprecated**: This modifier violates API responsibility boundaries by automatically
    /// applying UI styling decisions that should be controlled by the user.
    ///
    /// **Migration Path**: Use Garnish for color calculations only, then apply colors manually:
    /// ```swift
    /// // Old way:
    /// Text("Welcome").garnish(.white, .black, on: .all)
    ///
    /// // New way:
    /// let contrastingColor = Garnish.contrastingColor(of: .white, against: .black)
    /// Text("Welcome")
    ///     .foregroundColor(contrastingColor)
    ///     .background(.black)
    /// ```
    ///
    /// - Parameters:
    ///   - foreground: The intended foreground color.
    ///   - background: The intended background color.
    ///   - scope: The parts of the view to adjust. Defaults to `.all`.
    /// - Returns: A view with a foreground color that contrasts appropriately with the given background, depending on `scope`.
    @available(*, deprecated, message: "Use Garnish.contrastingColor(of:against:) and apply colors manually")
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
        if scope == .all {
            content
                .foregroundColor(
                    Garnish
                        .adjustForBackground(for: color, in: colorScheme, with: secondaryColor)
                )
                .background(secondaryColor)
        } else if scope == .foreground {
            content
                .foregroundColor(
                    Garnish
                        .adjustForBackground(for: color, in: colorScheme, with: secondaryColor)
                )
        } else if scope == .background {
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
        if scope == .all {
            content
                .foregroundColor(Garnish.contrastingForeground(for: color))
                .background(color)
        } else if scope == .foreground {
            content
                .foregroundColor(Garnish.contrastingForeground(for: color))
        } else if scope == .background {
            content
                .background(color)
        }
    }
}


// Preview removed - demo view was moved to new GarnishDemo.swift
