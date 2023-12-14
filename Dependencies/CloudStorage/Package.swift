// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CloudStorage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CloudStorage",
            targets: ["CloudStorage"]
        ),
        .library(
            name: "CloudStorageInterface",
            targets: ["CloudStorageInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../FirebaseSupport")
    ],
    targets: [
        .target(
            name: "CloudStorageInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "FirebaseSupport",
                    package: "FirebaseSupport"
                )
            ]
        ),
        .target(
            name: "CloudStorage",
            dependencies: [
                "CloudStorageInterface"
            ]
        )
    ]
)
