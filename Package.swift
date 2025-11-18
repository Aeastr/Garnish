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
            name: "GarnishExpansion",
            targets: ["GarnishExpansion"]
        ),
    ],
    targets: [
        .target(
            name: "Garnish"
        ),
        .target(
            name: "GarnishExpansion",
            dependencies: ["Garnish"]
        ),
        .testTarget(
            name: "GarnishTests",
            dependencies: ["Garnish"]
        ),
    ]
)
