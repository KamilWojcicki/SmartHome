// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SliderInfo",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SliderInfo",
            targets: ["SliderInfo"]
        ),
        .library(
            name: "SliderInfoInterface",
            targets: ["SliderInfoInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Animation"),
        .package(path: "../Design"),
        .package(path: "../Calendar"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Home"),
        .package(path: "../Navigation"),
        .package(path: "../Tasks"),
        .package(path: "../User")
    ],
    targets: [
        .target(
            name: "SliderInfoInterface",
            dependencies: [
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
            name: "SliderInfo",
            dependencies: [
                "SliderInfoInterface",
                .product(
                    name: "Animation",
                    package: "Animation"
                ),
                .product(
                    name: "Calendar",
                    package: "Calendar"
                ),
                .product(
                    name: "Design",
                    package: "Design"
                ),
                .product(
                    name: "Home",
                    package: "Home"
                ),
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "Tasks",
                    package: "Tasks"
                )
            ]
        )
    ]
)
