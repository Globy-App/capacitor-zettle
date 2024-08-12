// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GlobyZettle",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "GlobyZettle",
            targets: ["ZettlePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "ZettlePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/ZettlePlugin"),
        .testTarget(
            name: "ZettlePluginTests",
            dependencies: ["ZettlePlugin"],
            path: "ios/Tests/ZettlePluginTests")
    ]
)