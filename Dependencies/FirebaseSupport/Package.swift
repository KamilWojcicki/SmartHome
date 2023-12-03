// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseSupport",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FirebaseSupport",
            targets: ["FirebaseSupport"]
        ),
        .library(
            name: "FirebaseSupportInterface",
            targets: ["FirebaseSupportInterface"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            exact: "10.18.0"
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS.git",
            exact: "7.0.0"
        ),
        .package(
            url: "https://github.com/facebook/facebook-ios-sdk.git",
            exact: "16.2.1"
        )
    ],
    targets: [
        .target(
            name: "FirebaseSupportInterface",
            dependencies: [
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseFirestore",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseFirestoreSwift",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "GoogleSignInSwift",
                    package: "GoogleSignIn-iOS"
                ),
                .product(
                    name: "GoogleSignIn",
                    package: "GoogleSignIn-iOS"
                ),
                .product(
                    name: "FacebookLogin",
                    package: "facebook-ios-sdk"
                )
                
            ]
        ),
        .target(
            name: "FirebaseSupport",
            dependencies: ["FirebaseSupportInterface"]
        )
    ]
)
