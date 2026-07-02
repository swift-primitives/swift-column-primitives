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

public import Store_Protocol_Primitives

extension Column {
    /// The DIRECT-column capability marker — the axis-changing-alias fence ([DS-028] law 1).
    ///
    /// `Column.Direct` (the hoisted `__ColumnDirect`, homed at the `Store.`Protocol`` seam
    /// tier so the buffer disciplines can reach it) names the DIRECT canonical columns — the
    /// buffer-discipline stacks (``Heap``, ``Ring``) and storage-direct columns. `Shared` and
    /// bounded instantiations do NOT conform (that absence IS the fence): an axis-CHANGING
    /// front-door alias (allocation, e.g. `Array<E>.Small<n>`) constrains its column to
    /// `Column.Direct`, so a cross-axis chain that would silently reset an already-set axis
    /// fails to compile instead of dropping it without a diagnostic.
    ///
    /// It refines ``Store/`Protocol``` (so `Element` is available in axis-changing alias
    /// bodies with one constraint) and carries the capacity twin `BoundedTwin`, through which
    /// the column-PRESERVING `.Bounded` alias maps (`__X<S.BoundedTwin>`, [DS-028] law 2).
    ///
    /// This is the consumer-facing spelling; the marker's identity lives in
    /// `Store Protocol Primitives`.
    public typealias Direct = __ColumnDirect
}
