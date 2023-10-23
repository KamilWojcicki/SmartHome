// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Settings",
            targets: ["Settings"]
        ),
        .library(
            name: "SettingsInterface",
            targets: ["SettingsInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Authentication"),
        .package(path: "../Components"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "SettingsInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .target(
            name: "Settings",
            dependencies: [
                .product(
                    name: "Authentication",
                    package: "Authentication"
                ),
                .product(
                    name: "Components",
                    package: "Components"
                ),
                "SettingsInterface"
            ]
        )
    ]
)
