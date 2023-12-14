// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "NavigationInterface",
            targets: ["NavigationInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Design"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Localizations"),
        .package(path: "../Settings"),
        .package(path: "../SliderInfo"),
        .package(path: "../UserProfile")
    ],
    targets: [
        .target(
            name: "NavigationInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "UserProfile",
                    package: "UserProfile"
                )
            ]
        ),
        .target(
            name: "Navigation",
            dependencies: [
                .product(
                    name: "Design",
                    package: "Design"
                ),
                .product(
                    name: "Localizations",
                    package: "Localizations"
                ),
                .product(
                    name: "Settings",
                    package: "Settings"
                ),
                .product(
                    name: "SliderInfo",
                    package: "SliderInfo"
                ),
                "NavigationInterface"
            ]
        )
    ]
)
