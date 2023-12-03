// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "User",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "User",
            targets: ["User"]
        ),
        .library(
            name: "UserInterface",
            targets: ["UserInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Authentication"),
        .package(path: "../CloudDatabase"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Device")
    ],
    targets: [
        .target(
            name: "UserInterface",
            dependencies: [
                .product(
                    name: "Authentication",
                    package: "Authentication"
                ),
                .product(
                    name: "CloudDatabase",
                    package: "CloudDatabase"
                )
            ]
        ),
        .target(
            name: "User",
            dependencies: [
                "DependencyInjection",
                "UserInterface",
                .product(
                    name: "Device",
                    package: "Device"
                )
            ]
        )
    ]
)
