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
        .package(path: "../Components"),
        .package(path: "../Contact"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Localizations"),
        .package(path: "../User"),
        .package(path: "../Utilities")
    ],
    targets: [
        .target(
            name: "SettingsInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "User",
                    package: "User"
                ),
                .product(
                    name: "Contact",
                    package: "Contact"
                ),
                .product(
                    name: "Utilities",
                    package: "Utilities"
                )
            ]
        ),
        .target(
            name: "Settings",
            dependencies: [
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "Localizations",
                    package: "Localizations"
                ),
                "SettingsInterface"
            ]
        )
    ]
)
