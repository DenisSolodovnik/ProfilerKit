// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProfileKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ProfileKit", targets: ["ProfileKit"])
    ],
    targets: [
        .target(
            name: "ProfileKit",
            dependencies: [],
            swiftSettings: [
                .define("PROFILERKIT_ENABLED", .when(configuration: .debug))
            ]
        )
    ]
)
