// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CloudDatabase",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CloudDatabase",
            targets: ["CloudDatabase"]
        ),
        .library(
            name: "CloudDatabaseInterface",
            targets: ["CloudDatabaseInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../FirebaseSupport")
    ],
    targets: [
        .target(
            name: "CloudDatabaseInterface"
        ),
        .target(
            name: "CloudDatabase",
            dependencies: [
                "CloudDatabaseInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "FirebaseSupport",
                    package: "FirebaseSupport"
                )
            ]
        )
    ]
)
