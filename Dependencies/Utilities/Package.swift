// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        )
    ],
    dependencies: [
        .package(path: "../Localizations")
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [
                .product(
                    name: "Localizations",
                    package: "Localizations"
                )
            ],
            resources: [
                .process("Resources/")
            ]
        )
    ]
)
