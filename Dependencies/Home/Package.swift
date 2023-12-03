// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]
        ),
        .library(
            name: "HomeInterface",
            targets: ["HomeInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Localizations"),
        .package(path: "../Mqtt"),
        .package(path: "../Navigation"),
        .package(path: "../SliderInfo"),
        .package(path: "../User"),
        .package(path: "../Weather")
    ],
    targets: [
        .target(
            name: "HomeInterface",
            dependencies: [
                .product(
                    name: "Components",
                    package: "Components"
                )
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "HomeInterface",
                .product(
                    name: "Localizations",
                    package: "Localizations"
                ),
                .product(
                    name: "Mqtt",
                    package: "Mqtt"
                ),
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "SliderInfo",
                    package: "SliderInfo"
                ),
                .product(
                    name: "User",
                    package: "User"
                ),
                .product(
                    name: "Weather",
                    package: "Weather"
                )
            ]
        )
    ]
)
