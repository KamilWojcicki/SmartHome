// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Devices",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Devices",
            targets: ["Devices"]
        ),
        .library(
            name: "DevicesInterface",
            targets: ["DevicesInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Navigation"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Mqtt"),
        .package(path: "../ToDo"),
        .package(path: "../User")
    ],
    targets: [
        .target(
            name: "DevicesInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .target(
            name: "Devices",
            dependencies: [
                "DevicesInterface",
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "Mqtt",
                    package: "Mqtt"
                ),
                .product(
                    name: "ToDo",
                    package: "ToDo"
                ),
                .product(
                    name: "User",
                    package: "User"
                )
            ]
        )
    ]
)
