// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Root",
            targets: ["Root"]
        ),
        .library(
            name: "RootInterface",
            targets: ["RootInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../Onboarding"),
        .package(path: "../SliderInfo")
    ],
    targets: [
        .target(
            name: "RootInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection")
            ]
        ),
        .target(
            name: "Root",
            dependencies: [
                "RootInterface",
                .product(
                    name: "Onboarding",
                    package: "Onboarding"
                ),
                .product(
                    name: "SliderInfo",
                    package: "SliderInfo"
                )
            ]
        )
    ]
)
