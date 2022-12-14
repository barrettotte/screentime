// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScreenTime",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/stephencelis/SQLite.swift.git",
            from: "0.14.1"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "ScreenTime",
            dependencies: ["ScreenTimeCore"]),
        .target(name: "ScreenTimeCore")
        .testTarget(
            name: "ScreenTimeTests",
            dependencies: ["ScreenTimeCore"]),
    ]
)
