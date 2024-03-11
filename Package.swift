// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiiaPublicServices",
    defaultLocalization: "uk",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DiiaPublicServicesCore",
            targets: ["DiiaPublicServicesCore"]),
        .library(
            name: "DiiaPublicServices",
            targets: ["DiiaPublicServices"]),
    ],
    dependencies: [
        .package(url: "https://github.com/diia-open-source/ios-mvpmodule.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-network.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-commontypes.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-uicomponents.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-commonservices.git", .upToNextMinor(from: Version(1, 0, 0))),
    ],
    //
    targets: [
        .target(
            name: "DiiaPublicServicesCore",
            dependencies: [
                .product(name: "DiiaMVPModule", package: "ios-mvpmodule"),
                .product(name: "DiiaNetwork", package: "ios-network"),
                .product(name: "DiiaUIComponents", package: "ios-uicomponents"),
                .product(name: "DiiaCommonTypes", package: "ios-commontypes"),
                .product(name: "DiiaCommonServices", package: "ios-commonservices"),
            ],
            path: "Sources/PublicServicesCore"
        ),
        .target(
            name: "DiiaPublicServices",
            dependencies: [
                .product(name: "DiiaMVPModule", package: "ios-mvpmodule"),
                .product(name: "DiiaUIComponents", package: "ios-uicomponents"),
                .product(name: "DiiaNetwork", package: "ios-network"),
                .product(name: "DiiaCommonTypes", package: "ios-commontypes"),
                .product(name: "DiiaCommonServices", package: "ios-commonservices"),
            ],
            path: "Sources/PublicServices"
        ),
        .testTarget(
            name: "DiiaPublicServicesCoreTests",
            dependencies: ["DiiaPublicServicesCore"],
            path: "Tests/PublicServicesCoreTests"
        ),
        .testTarget(
            name: "DiiaPublicServicesTests",
            dependencies: ["DiiaPublicServices"],
            path: "Tests/PublicServicesTests"
        ),
    ]
)
