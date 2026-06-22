// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-column-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        // MARK: - The column vocabulary (one importable module; pure typealiases)
        .library(name: "Column Primitives", targets: ["Column Primitives"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-buffer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-buffer-linear-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-buffer-ring-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-storage-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-storage-generational-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-shared-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-heap-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-allocation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-index-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
    ],
    targets: [

        // MARK: - The vocabulary (zero re-exports; consumers import it explicitly)
        .target(
            name: "Column Primitives",
            dependencies: [
                .product(name: "Buffer Primitive", package: "swift-buffer-primitives"),
                .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear-primitives"),
                .product(name: "Buffer Linear Bounded Primitive", package: "swift-buffer-linear-primitives"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Storage Primitive", package: "swift-storage-primitives"),
                .product(name: "Storage Contiguous Primitives", package: "swift-storage-primitives"),
                .product(name: "Store Inline Primitives", package: "swift-storage-primitives"),
                .product(name: "Storage Generational Primitives", package: "swift-storage-generational-primitives"),
                .product(name: "Shared Primitive", package: "swift-shared-primitives"),
                .product(name: "Memory Primitive", package: "swift-memory-primitives"),
                .product(name: "Memory Heap Primitives", package: "swift-memory-heap-primitives"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation-primitives"),
                .product(name: "Memory Allocator Pool Primitives", package: "swift-memory-allocation-primitives"),
            ]
        ),

        // MARK: - Tests
        .testTarget(
            name: "Column Primitives Tests",
            dependencies: [
                "Column Primitives",
                .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear-primitives"),
                .product(name: "Buffer Linear Bounded Primitive", package: "swift-buffer-linear-primitives"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Buffer Ring Bounded Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Store Inline Primitives", package: "swift-storage-primitives"),
                .product(name: "Storage Generational Primitives", package: "swift-storage-generational-primitives"),
                .product(name: "Shared Primitive", package: "swift-shared-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Tagged Primitives Standard Library Integration", package: "swift-tagged-primitives"),
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
