// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCase",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UseCase",
            targets: ["UseCase"]),
    ],
    dependencies: [
      .package(path: "../DomainPackage"),
      .package(path: "../RepositoryPackage"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "UseCase",
          dependencies: [
            .product(name: "Domain", package: "DomainPackage"),
            .product(name: "Repository", package: "RepositoryPackage")]
        ),
        .testTarget(
            name: "UseCaseTests",
            dependencies: ["UseCase"]
        ),
    ]
)
