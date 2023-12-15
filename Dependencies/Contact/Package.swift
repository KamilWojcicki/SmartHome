// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Contact",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Contact",
            targets: ["Contact"]
        ),
        .library(
            name: "ContactInterface",
            targets: ["ContactInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Localizations")
    ],
    targets: [
        .target(
            name: "ContactInterface",
            dependencies: [
                .product(
                    name: "Localizations",
                    package: "Localizations"
                )
            ]
        ),
        .target(
            name: "Contact",
            dependencies: [
                "ContactInterface"
            ]
        )
    ]
)
