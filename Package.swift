// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modulus",
	platforms: [
		.iOS(.v15),
		.macOS(.v10_15)
	],
    products: [
        .library(
            name: "Modulus",
            targets: ["Modulus"]
		),
    ],
    targets: [
        .target(
            name: "Modulus"
		),
        .testTarget(
            name: "ModulusTests",
            dependencies: ["Modulus"]
        ),
    ]
)
