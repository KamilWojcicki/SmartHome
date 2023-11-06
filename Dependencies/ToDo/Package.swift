// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ToDo",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ToDo",
            targets: ["ToDo"]
        ),
        .library(
            name: "ToDoInterface",
            targets: ["ToDoInterface"]
        )
    ],
    dependencies: [
        .package(path: "../CloudDatabase"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "ToDoInterface",
            dependencies: [
                .product(
                    name: "CloudDatabase",
                    package: "CloudDatabase"
                )
            ]
        ),
        .target(
            name: "ToDo",
            dependencies: [
                "ToDoInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        )
    ]
)
