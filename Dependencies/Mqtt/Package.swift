// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Mqtt",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MqttInterface",
            targets: ["MqttInterface"]
        ),
        .library(
            name: "Mqtt",
            targets: ["Mqtt"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/emqx/CocoaMQTT.git",
            exact: "2.1.5"
        ),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "MqttInterface",
            dependencies: [
                .product(
                    name: "CocoaMQTT",
                    package: "CocoaMQTT"
                ),
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .target(
            name: "Mqtt",
            dependencies: [
                "MqttInterface"
            ]
        )
    ]
)
