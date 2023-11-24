// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Localizations",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Localizations",
            targets: ["Localizations"]
        )
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Localizations",
            dependencies: [],
            resources: [.process("Resources/")]
        )
    ]
)
