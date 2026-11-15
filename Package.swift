
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TienDat",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "TienDat",
            targets: ["TienDatApp"]
        )
    ],
    targets: [
        .target(
            name: "TienDatC",
            path: "Sources/TienDatC",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedLibrary("z")
            ]
        ),
        .target(
            name: "TienDatObjC",
            dependencies: ["TienDatC"],
            path: "Sources/TienDatObjC",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation")
            ]
        ),
        .target(
            name: "TienDatApp",
            dependencies: [
                "TienDatObjC",
                "TienDatC"
            ],
            path: "Sources/TienDatApp"
        )
    ]
)
