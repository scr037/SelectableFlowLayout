// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SelectableFlowLayout",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "ToggleStyles",
      targets: ["ToggleStyles"]
    ),
    .library(
      name: "FlowLayout",
      targets: ["FlowLayout"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.11.1"
    ),
    .package(
      url: "https://github.com/pointfreeco/combine-schedulers.git",
      from: "1.0.0"
    )
  ],
  targets: [
    .target(
      name: "ToggleStyles",
      dependencies: []
    ),
    .testTarget(
      name: "ToggleStylesTests",
      dependencies: [
        "ToggleStyles",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FlowLayout",
      dependencies: [
        .target(name: "ToggleStyles"),
        .productItem(name: "CombineSchedulers", package: "combine-schedulers"),
      ]
    ),
    .testTarget(
      name: "FlowLayoutTests",
      dependencies: [
        "FlowLayout",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: ["__Snapshots__"]
    ),
  ]
)
