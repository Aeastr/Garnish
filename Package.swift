// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Garnish",
    platforms: [
        .iOS(.v14),
        .macOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Garnish",
            targets: ["Garnish"]
        ),
        .library(
            name: "GarnishTheme",
            targets: ["GarnishTheme"]
        ),
    ],
    targets: [
        .target(
            name: "Garnish"
        ),
        .target(
            name: "GarnishTheme",
            dependencies: ["Garnish"]
        ),
        .testTarget(
            name: "GarnishTests",
            dependencies: ["Garnish"]
        ),
        .testTarget(
            name: "GarnishThemeTests",
            dependencies: ["GarnishTheme"]
        ),
    ]
)
