// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTPServerIO",
    products: [
        .library(name: "HTTPServerIO", targets: ["HTTPServerIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/viralplatipuss/SimpleFunctional.git", .exact("0.0.11")),
        .package(url: "https://github.com/vapor/http.git", .exact("3.3.2")),
    ],
    targets: [
        .target(name: "HTTPServerIO", dependencies: ["SimpleFunctional", "HTTP"]),
    ]
)
