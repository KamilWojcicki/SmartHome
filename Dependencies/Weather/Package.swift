// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Weather",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "WeatherInterface",
            targets: ["WeatherInterface"]
        ),
        .library(
            name: "Weather",
            targets: ["Weather"]
        ),
    ],
    dependencies: [
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "WeatherInterface"
        ),
        .target(
            name: "Weather",
            dependencies: [
                "WeatherInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        )        
    ]
)
