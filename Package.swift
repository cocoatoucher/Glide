// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GlideEngine",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v12)
    ],
    products: [
        .library(name: "GlideEngine", targets: ["Glide"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Glide", path: "Sources"),
        .testTarget(name: "Glide-Tests", dependencies: ["Glide"], path: "Tests")
    ]
)
