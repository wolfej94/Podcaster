// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SparrowTek/PodcastIndexKit", from: "0.4.1"),
        .package(path: "../Storage")
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: ["PodcastIndexKit", "Storage"]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
    ]
)

