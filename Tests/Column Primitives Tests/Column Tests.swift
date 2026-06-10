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
//
// The vocabulary smoke: every ruled member SPELLS and CONSTRUCTS its canonical
// column (an alias-typed binding accepts the canonical constructor), including a
// ~Copyable element through the suppression-carrying aliases. Member access rides
// the explicitly-imported column modules (Audit-#9 — the vocabulary re-exports
// nothing).

import Testing
import Column_Primitives
import Buffer_Linear_Primitive
import Buffer_Linear_Bounded_Primitive
import Buffer_Ring_Primitive
import Buffer_Ring_Bounded_Primitive
import Store_Inline_Primitives
import Storage_Generational_Primitives
import Shared_Primitive
import Index_Primitives
import Tagged_Primitives_Standard_Library_Integration

private struct MoveOnly: ~Copyable { var v: Int }

@Suite
struct ColumnVocabularyTests {

    @Test
    func `Heap spells the growable heap column for both element kinds`() {
        var c = Column.Heap<Int>(minimumCapacity: Index<Int>.Count(UInt(2)))
        c.append(1)
        c.append(2)
        c.append(3)
        #expect(c.count == 3)
        var m = Column.Heap<MoveOnly>()
        m.append(MoveOnly(v: 7))
        #expect(m.count == 1)
    }

    @Test
    func `Bounded spells the fixed-capacity linear column`() {
        let c = Column.Bounded<Int>(minimumCapacity: 4)
        let empty = c.isEmpty
        #expect(empty)
    }

    @Test
    func `Ring spells the cyclic column; the bounded ring chains through the alias`() throws {
        var r = Column.Ring<Int>(minimumCapacity: 4)
        r.push.back(1)
        r.push.back(2)
        #expect(r.count == 2)
        let b = try Column.Ring<Int>.Bounded([10, 20], capacity: 4)
        #expect(b.count == 2)
    }

    @Test
    func `Inline spells the typed inline column with its value-generic capacity`() {
        var s = Column.Inline<Int, 4>()
        s.initialize(at: 0, to: 11)
        #expect(s.count == 1)
        let taken = s.move(at: 0)
        #expect(taken == 11)
    }

    @Test
    func `Generational spells the sparse pool column`() {
        var g = Column.Generational<Int>.create(slotCapacity: 2)
        let h = g.insert(9)
        let live = g.contains(h)
        #expect(live)
        let removed = g.remove(h)
        #expect(removed == 9)
    }

    @Test
    func `Shared spells the CoW column over the heap backing`() {
        var a = Column.Shared<Int>(Column.Heap<Int>(minimumCapacity: Index<Int>.Count(UInt(4))))
        a.withUnique { $0.append(1) }
        let b = a
        a.withUnique { $0.append(2) }
        #expect(a.count == 2)
        #expect(b.count == 1)
    }
}
