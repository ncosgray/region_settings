// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "region_settings",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "region-settings", targets: ["region_settings"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "region_settings",
            dependencies: [],
            resources: []
        )
    ]
)