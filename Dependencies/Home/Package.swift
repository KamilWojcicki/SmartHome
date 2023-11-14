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
        .package(path: "../Navigation"),
        .package(path: "../User"),
        .package(path: "../SliderInfo"),
        .package(path: "../Mqtt")
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
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "User",
                    package: "User"
                ),
                .product(
                    name: "SliderInfo",
                    package: "SliderInfo"
                ),
                .product(
                    name: "Mqtt",
                    package: "Mqtt"
                )
            ]
        )
    ]
)
