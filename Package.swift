// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Micro",
    products: [
        .library(
            name: "Micro",
            targets: ["Micro"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/onmyway133/DeepDiff.git", from: "2.3.1"),
    ],
    targets: [
        .target(
            name: "Micro",
            dependencies: [
                "DeepDiff"
            ]
        ),
        .testTarget(
            name: "MicroTests",
            dependencies: ["Micro"]
        ),
    ]
)
