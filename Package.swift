// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "iOSSDK",
            targets: ["iOSSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/paololeonardi/WaterfallGrid.git", from: "0.4.0"),
        .package(name:"FontAwesome",url: "https://github.com/thii/FontAwesome.swift", from: "1.0.0"),
        .package(name:"SQLite.swift",url:"https://github.com/stephencelis/SQLite.swift",from: "0.0.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/exyte/Macaw",from:"0.9.7")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "iOSSDK",
            dependencies: ["FontAwesome",
                           "WaterfallGrid",
                           "Macaw",
                           "SkeletonView",
                           .product(name: "SQLite", package: "SQLite.swift"),]),
        .testTarget(
            name: "iOSSDKTests",
            dependencies: ["iOSSDK"]),
    ]
)
