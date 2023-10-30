// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(path: "../DependencyInjection")
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
                "UserInterface"
            ]
        )
    ]
)
