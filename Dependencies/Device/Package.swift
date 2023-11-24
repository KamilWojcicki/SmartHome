// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Device",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Device",
            targets: ["Device"]
        ),
        .library(
            name: "DeviceInterface",
            targets: ["DeviceInterface"]
        )
    ],
    dependencies: [
        .package(path: "../CloudDatabase"),
        .package(path: "../DependencyInjection"),
        .package(path: "../User")
    ],
    targets: [
        .target(
            name: "DeviceInterface",
            dependencies: [
                .product(
                    name: "CloudDatabase",
                    package: "CloudDatabase"
                )
            ]
        ),
        .target(
            name: "Device",
            dependencies: [
                "DeviceInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "User",
                    package: "User"
                )
            ]
        )
    ]
)
