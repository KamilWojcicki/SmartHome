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
        .package(path: "../Calendar"),
        .package(path: "../DependencyInjection"),
        .package(path: "../Home"),
        .package(path: "../Navigation"),
        .package(path: "../Onboarding"),
        .package(path: "../Tasks")
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
                    name: "Calendar",
                    package: "Calendar"
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
                    name: "Onboarding",
                    package: "Onboarding"
                ),
                .product(
                    name: "Tasks",
                    package: "Tasks"
                )
            ]
        )
    ]
)
