//
//  GarnishThemeError.swift
//  GarnishTheme
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

/// Errors that can occur during theme operations
public enum GarnishThemeError: LocalizedError {
    case themeNotFound(String)
    case colorNotCached(ColorKey, scheme: ColorScheme)
    case colorNotDefined(ColorKey, themeName: String)
    case themeAlreadyExists(String)
    case colorTransformationFailed(ColorKey)
    case coreDataError(Error)

    public var errorDescription: String? {
        switch self {
        case .themeNotFound(let name):
            return "Theme '\(name)' not found"
        case let .colorNotCached(key, scheme):
            return "Color '\(key.stringValue)' not cached for \(scheme == .light ? "light" : "dark") mode"
        case let .colorNotDefined(key, themeName):
            return "Color '\(key.stringValue)' not defined in theme '\(themeName)'"
        case .themeAlreadyExists(let name):
            return "Theme '\(name)' already exists"
        case .colorTransformationFailed(let key):
            return "Failed to transform color data for '\(key.stringValue)'"
        case .coreDataError(let error):
            return "CoreData error: \(error.localizedDescription)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .themeNotFound:
            return "Check that the theme name is correct or create a new theme"
        case .colorNotCached:
            return "Ensure the theme has been properly loaded and cached"
        case .colorNotDefined:
            return "Define the color using theme[key] = Color before accessing"
        case .themeAlreadyExists:
            return "Use a different name or load the existing theme"
        case .colorTransformationFailed:
            return "Check that the color data is valid and not corrupted"
        case .coreDataError:
            return "Check CoreData stack and storage availability"
        }
    }
}
