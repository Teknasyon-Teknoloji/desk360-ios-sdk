// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Desk360",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Desk360",
            targets: ["Desk360"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/Teknasyon-Teknoloji/PersistenceKit.git", .branch("master")),
        .package(url: "https://github.com/devicekit/DeviceKit.git", .upToNextMajor(from: "4.0.0"))

        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Desk360",
            dependencies: [
                "SnapKit",
                "Moya",
                "PersistenceKit",
                "DeviceKit"

            ],
            path: "Sources"
            /*resources: [
                "Sources/Desk360.plist"
            ]*/
        )
    ]
)
