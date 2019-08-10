// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "GlideEngine",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v12)
    ],
    products: [
        .library(name: "GlideEngine", targets: ["GlideEngine"])
    ],
    dependencies: [],
    targets: [
        .target(name: "GlideEngine", path: "Sources"),
        .testTarget(name: "GlideEngine-Tests", dependencies: ["GlideEngine"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
