// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Garnish",
    platforms: [
        .iOS(.v14),
        .macOS("13.3"),
        .tvOS(.v14),
        .watchOS(.v7)
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
