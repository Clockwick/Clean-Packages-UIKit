// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "UI",targets: ["UI"]),
    ],
    dependencies: [
      .package(path: "../UtilsPackage")
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [.product(name: "Utils", package: "UtilsPackage")]
        ),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]
        ),
    ]
)
