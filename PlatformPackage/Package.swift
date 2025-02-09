// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Platform",
            targets: ["Platform"]),
    ],
    dependencies: [
      .package(path: "../DomainPackage"),
      .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "20.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "Platform", dependencies: [
            .product(name: "Domain", package: "DomainPackage"),
            .product(name: "RealmSwift", package: "realm-swift")
          ]),
        .testTarget(
            name: "PlatformTests",
            dependencies: ["Platform"]
        ),
    ]
)
