// swift-tools-version:5.7.1

import PackageDescription

let package = Package(
    name: "RealTimePicker",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "RealTimePicker",
            targets: ["RealTimePicker"]
        ),
    ],
    targets: [
        .target(
            name: "RealTimePicker",
            path: "RealTimePicker",
            exclude: [
                "RealTimePicker.h",
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
