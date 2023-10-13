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
        .package(path: "../Authentication"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "NavigationInterface",
            dependencies: [
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ]
        ),
        .target(
            name: "Navigation",
            dependencies: [
                .product(name: "Design", package: "Design"),
                .product(name: "Authentication", package: "Authentication"),
                "NavigationInterface"
            ]
        )
    ]
)
