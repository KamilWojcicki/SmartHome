// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calendar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Calendar",
            targets: ["Calendar"]
        ),
        .library(
            name: "CalendarInterface",
            targets: ["CalendarInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "CalendarInterface",
            dependencies: [
                .product(
                    name: "Components",
                    package: "Components"
                )
            ]
        ),
        .target(
            name: "Calendar",
            dependencies: [
                "CalendarInterface",
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        )
        
    ]
)
