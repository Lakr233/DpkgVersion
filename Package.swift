// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DpkgVersion",
    products: [
        .library(
            name: "DpkgVersion",
            targets: ["DpkgVersion"]
        ),
    ],
    targets: [
        .target(name: "DpkgVersion"),
        .testTarget(name: "DpkgVersionTests", dependencies: ["DpkgVersion"]),
    ]
)
