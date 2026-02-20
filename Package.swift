// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProfilerKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ProfilerKit", targets: ["ProfilerKit"])
    ],
    targets: [
        .target(
            name: "ProfilerKit",
            dependencies: [],
            swiftSettings: [
                .define("PROFILERKIT_ENABLED", .when(configuration: .debug))
            ]
        )
    ]
)
