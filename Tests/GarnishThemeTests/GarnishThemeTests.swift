//
//  GarnishThemeTests.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import GarnishTheme

final class GarnishThemeTests: XCTestCase {
    func testBuiltInThemes() throws {
        // Test that built-in themes exist
        let defaultTheme = GarnishTheme.builtin("Default")
        XCTAssertNotNil(defaultTheme)
        XCTAssertEqual(defaultTheme?.name, "Default")

        let darkTheme = GarnishTheme.builtin("Dark")
        XCTAssertNotNil(darkTheme)
        XCTAssertEqual(darkTheme?.name, "Dark")

        let oceanTheme = GarnishTheme.builtin("Ocean")
        XCTAssertNotNil(oceanTheme)
        XCTAssertEqual(oceanTheme?.name, "Ocean")
    }

    func testColorKeyExtensions() throws {
        // Test ColorKey string conversion
        let primaryKey = ColorKey.primary
        XCTAssertEqual(primaryKey.stringValue, "primary")
        XCTAssertTrue(primaryKey.isStandard)

        let customKey = ColorKey.custom("accent")
        XCTAssertEqual(customKey.stringValue, "accent")
        XCTAssertFalse(customKey.isStandard)

        // Test ColorKey creation from string
        let keyFromString = ColorKey(from: "primary")
        XCTAssertEqual(keyFromString, .primary)

        let customFromString = ColorKey(from: "accent")
        XCTAssertEqual(customFromString, .custom("accent"))
    }

    func testCurrentThemeWrapper() throws {
        // Test CurrentTheme with built-in theme
        let builtInTheme = GarnishTheme.builtin("Default")!
        let currentBuiltIn = CurrentTheme.from(builtIn: builtInTheme)

        XCTAssertEqual(currentBuiltIn.name, "Default")
        XCTAssertTrue(currentBuiltIn.isBuiltIn)

        // Test color access
        let primaryColor = try currentBuiltIn.primary(for: .light)
        XCTAssertNotNil(primaryColor)
    }
}
