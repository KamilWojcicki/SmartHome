// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "DependencyInjection",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            exact: "2.8.3"
        ),
        .package(
            url: "https://github.com/Swinject/SwinjectStoryboard.git",
            .upToNextMajor(from: "2.2.0")
        )
    ],
    targets: [
        .target(
            name: "DependencyInjection",
            dependencies: [
                .product(
                    name: "Swinject",
                    package: "Swinject"
                ),
                .product(
                    name: "SwinjectStoryboard",
                    package: "SwinjectStoryboard"
                )
            ]
        )
    ]
)
