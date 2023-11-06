// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Devices",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Devices",
            targets: ["Devices"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Devices",
            dependencies: [
                
            ]
        )
    ]
)
