// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tasks",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Tasks",
            targets: ["Tasks"]
        ),
        .library(
            name: "TasksInterface",
            targets: ["TasksInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "TasksInterface",
            dependencies: [
                .product(
                    name: "Components",
                    package: "Components"
                )
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
                "TasksInterface",
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        )
    ]
)
