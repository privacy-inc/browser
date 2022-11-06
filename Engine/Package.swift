// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Engine",
            targets: ["Engine"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main"),
        .package(url: "https://github.com/privacy-inc/domains.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Engine",
            dependencies: [
                .product(name: "Archivable", package: "package"),
                .product(name: "Domains", package: "domains")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Engine"],
            path: "Tests")
    ]
)
