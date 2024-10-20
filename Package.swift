// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EigV",
    platforms: [.macOS(.v13), .macCatalyst(.v16)],
    products: [
        .library(
            name: "EigV",
            targets: ["EigV"]
        ),
    ],
    targets: [
        .target(
            name: "EigV",
            cxxSettings: [
                .define("ACCELERATE_NEW_LAPACK", to: "1")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
        .testTarget(
            name: "EigVTests",
            dependencies: ["EigV"]
        ),
    ]
)
