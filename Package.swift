// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Garnish",
    platforms: [
        .iOS(.v14),
        .macOS("13.3"),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Garnish",
            targets: ["Garnish"]
        ),
    ],
    targets: [
        .target(
            name: "Garnish"
        ),
        .testTarget(
            name: "GarnishTests",
            dependencies: ["Garnish"]
        ),
    ]
)
