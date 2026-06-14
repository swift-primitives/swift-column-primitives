# Column Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-column-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-column-primitives/actions/workflows/ci.yml)

`Column` — the canonical storage-column compositions, as named typealiases. A column is a `Buffer` discipline laid over a `Storage` substrate over a `Memory` allocator; spelling that composition out in full (`Buffer<Storage<Memory.Allocator<Memory.Heap>.System>.Contiguous<E>>.Linear`) at every use site is noise. `Column` names the canonical ones once — **`Column.Heap`** (growable, heap-backed), **`Column.Bounded`** (fixed-capacity, rejects on overflow), and their siblings — so consumers and ADTs name a column by intent, not by its full substrate stack.

This package is pure composition: no new types, just the ready-made typealiases the higher layers build on. Each resolves to a concrete `Buffer.*` over a concrete `Storage`, so there is no abstraction cost — `Column.Heap<Int>` *is* `Buffer<…>.Linear`.

---

## Key Features

- **Name a column by intent** — `Column.Heap<Element>` and `Column.Bounded<Element>` instead of the full `Buffer × Storage × Memory` spelling.
- **Zero-cost aliases** — each `Column.*` is a `typealias` to a concrete composition; no wrapper, no indirection.
- **`~Copyable` elements** — the compositions carry move-only elements through unchanged.
- **One place to evolve** — when the canonical substrate stack changes, it changes here, and every consumer follows.

---

## Quick Start

```swift
import Column_Primitives

// The growable heap column — no substrate spelling required:
typealias Ints = Column.Heap<Int>

// instead of:
// typealias Ints = Buffer<Storage<Memory.Allocator<Memory.Heap>.System>.Contiguous<Int>>.Linear
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-column-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Column Primitives", package: "swift-column-primitives")
    ]
)
```

The package is pre-1.0 — depend on `branch: "main"` until `0.1.0` is tagged. Requires Swift 6.3 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

| Product | Contents | When to import |
|---------|----------|----------------|
| `Column Primitives` | `Column` — the canonical column typealiases (`Heap`, `Bounded`, …) | Naming a ready-made column |

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS 26         | Yes | Full support |
| Linux            | Yes | Full support |
| Windows          | Yes | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Swift Embedded   | —   | Pending (nightly-toolchain follow-up) |

---

## Related Packages

- [`swift-buffer-primitives`](https://github.com/swift-primitives/swift-buffer-primitives) — the `Buffer` disciplines a column is composed from.
- [`swift-storage-primitives`](https://github.com/swift-primitives/swift-storage-primitives) — the `Storage` substrate underneath.
- [`swift-store-primitives`](https://github.com/swift-primitives/swift-store-primitives) — `Store.Protocol`, the column capability these compositions satisfy.
- [`swift-memory-primitives`](https://github.com/swift-primitives/swift-memory-primitives) — `Memory.Allocator`, the allocation strategy a column is parameterized over.

---

## Community

<!-- BEGIN: discussion -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
