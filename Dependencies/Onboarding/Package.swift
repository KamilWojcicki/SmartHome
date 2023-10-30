// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]
        ),
        .library(
            name: "OnboardingInterface",
            targets: ["OnboardingInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../User")
    ],
    targets: [
        .target(
            name: "OnboardingInterface",
            dependencies: []
        ),
        .target(
            name: "Onboarding",
            dependencies: [
                "OnboardingInterface",
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "User",
                    package: "User"
                )
            ]
        )
    ]
)
