// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevTool",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DevTool",
            targets: ["DevTool"]),
    ],
    dependencies: [
      .package(path: "../UseCasePackage"),
      .package(path: "../UIPackage"),
    ],
    targets: [
        .target(
          name: "DevTool",
          dependencies: [
            .product(name: "UseCase", package: "UseCasePackage"),
            .product(name: "UI", package: "UIPackage"),
          ]),
    ]
)
