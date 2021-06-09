// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxTestExt",
    products: [
        .library(
            name: "RxTestExt",
            targets: ["RxTestExt"]),
    ],
    dependencies: [
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "RxTestExt",
            dependencies: [
                .product(name: "RxTest", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
            ],
            path: "RxTestExt"),
        .testTarget(
            name: "RxTestExtTests",
            dependencies: ["RxTestExt"],
            path: "RxTestExtTests")
    ]
)
