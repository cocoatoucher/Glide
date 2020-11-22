// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "GlideEngine",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14)
    ],
    products: [
        .library(name: "GlideEngine", targets: ["GlideEngine"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GlideEngine",
            path: "Sources"),
        .testTarget(
            name: "GlideEngine-Tests",
            dependencies: ["GlideEngine"],
            path: "Tests",
            exclude: [
                "CollisionsTests/Contact Sides/Reference gifs/combined",
                "CollisionsTests/Contact Sides/Reference gifs/right",
                "CollisionsTests/Contact Sides/Reference gifs/left",
                "CollisionsTests/Contact Sides/Reference gifs/top",
                "CollisionsTests/Contact Sides/Reference gifs/bottom",
                "Info.plist"
            ])
    ],
    swiftLanguageVersions: [.v5]
)
