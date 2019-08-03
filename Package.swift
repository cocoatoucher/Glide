// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Glide",
    platforms: [
        .macOS(.v10_14), .iOS(.v11), .tvOS(.v12)
    ],
    products: [
        .library(name: "Glide", targets: ["Glide"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Glide", path: "Sources")
    ]
)
