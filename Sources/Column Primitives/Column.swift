// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Buffer_Ring_Primitive
public import Memory_Allocator_Pool_Primitives
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
public import Memory_Primitive
public import Ownership_Shared_Primitive
public import Storage_Contiguous_Primitives
public import Storage_Generational_Primitives
public import Storage_Primitive
public import Store_Inline_Primitives

/// The COLUMN VOCABULARY (principal-ruled 2026-06-10: namespace `Column`,
/// resource-true members) — generic typealiases for the tower's full column
/// spellings, so consumer signatures read
/// `Array<Column.Heap<Int>>` instead of
/// `Array<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear>`.
///
/// ## Pure typealiases, zero re-exports
///
/// Importing this module gives you the SPELLINGS only (R4 Option A,
/// probe-verified: aliases are zero-cost — they are not types, so no dispatch
/// is added and no `@frozen` applies). Members and conformances of the
/// underlying columns resolve against the modules that declare them — import
/// the column-vocabulary modules you use explicitly (Audit-#9).
///
/// ## Members (resource-true — the names consumers already see in diagnostics)
///
/// - ``Heap`` — the growable heap column (`Buffer.Linear` over system-allocated
///   contiguous storage): the default backing.
/// - ``Bounded`` — the fixed-capacity linear column (`Buffer.Linear.Bounded`);
///   the seam-conforming bounded buffer (`Array.Bounded`'s replacement).
/// - ``Ring`` — the growable cyclic column (`Buffer.Ring`); spell the bounded
///   ring through it as `Column.Ring<E>.Bounded` (the nesting chains through
///   the alias).
/// - ``Inline`` — the typed inline column (`Store.Inline<E, n>`): elements live
///   in the value itself, capacity in the type.
/// - ``Generational`` — the sparse handle-validated column over the heap pool
///   (`Storage.Generational`).
/// - ``Shared`` — the explicit copy-on-write value-semantic column over the
///   heap backing (`Ownership.Shared<E, Column.Heap<E>>`); value-semantic payloads take
///   this column (the B-class guidance).
///
/// New members land with their families (e.g. `Small` rides the deferred Q2
/// `Store.Small`).
public enum Column {}

extension Column {
    /// The growable heap column — `Buffer.Linear` over system-allocated
    /// contiguous storage.
    public typealias Heap<E: ~Copyable> =
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear

    /// The fixed-capacity linear column — `Buffer.Linear.Bounded` (rejects on
    /// overflow with typed throws at the family surface).
    public typealias Bounded<E: ~Copyable> =
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded

    /// The growable cyclic column — `Buffer.Ring`.
    ///
    /// The bounded ring is `Column.Ring<E>.Bounded` (the nesting chains
    /// through the alias).
    public typealias Ring<E: ~Copyable> =
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Ring

    /// The typed inline column — `Store.Inline<E, n>`: elements live in the
    /// value itself (no allocation), capacity in the type.
    public typealias Inline<E: ~Copyable, let n: Int> = Store.Inline<E, n>

    /// The sparse handle-validated column over the heap pool —
    /// `Storage.Generational` (the SlotMap substrate).
    public typealias Generational<E: ~Copyable> =
        Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<E>

    /// The explicit copy-on-write value-semantic column over the heap backing.
    ///
    /// Value-semantic payloads (stored properties, enum payloads) take this
    /// column; direct columns make the enclosing type move-only.
    public typealias Shared<E: ~Copyable> = Ownership.Shared<E, Heap<E>>
}
