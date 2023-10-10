// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]
        )
    ],
    dependencies: [
        .package(path: "../Animation"),
        .package(path: "../Design")
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                .product(name: "Animation", package: "Animation"),
                .product(name: "Design", package: "Design")
            ]
        )
    ]
)
