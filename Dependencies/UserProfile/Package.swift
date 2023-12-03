// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UserProfile",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UserProfile",
            targets: ["UserProfile"]
        ),
        .library(
            name: "UserProfileInterface",
            targets: ["UserProfileInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "UserProfileInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .target(
            name: "UserProfile",
            dependencies: [
                "UserProfileInterface"
            ]
        )
    ]
)
