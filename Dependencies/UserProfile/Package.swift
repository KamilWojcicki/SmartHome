// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UserProfile",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UserProfile",
            targets: ["UserProfile"]
        ),
        .library(
            name: "UserProfileInterface",
            targets: ["UserProfileInterface"]
        )
    ],
    dependencies: [
        .package(path: "../CloudStorage"),
        .package(path: "../Components"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Localizations"),
        .package(path: "../User")
    ],
    targets: [
        .target(
            name: "UserProfileInterface",
            dependencies: [
                .product(
                    name: "CloudStorage",
                    package: "CloudStorage"
                ),
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "User",
                    package: "User"
                )
            ]
        ),
        .target(
            name: "UserProfile",
            dependencies: [
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "Localizations",
                    package: "Localizations"
                ),
                "UserProfileInterface"
            ]
        )
    ]
)
