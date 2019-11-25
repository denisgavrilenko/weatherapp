//
//  EndlessSequenseTests.swift
//  weatherappTests
//
//  Created by Denis Gavrilenko on 11/25/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import XCTest

class EndlessSequenseTests: XCTestCase {

    private func checkEqual<T: Equatable>(value: @autoclosure () -> T?, with other: T) {
        let next = value()
        XCTAssertNotNil(next)
        XCTAssertEqual(next!, other)
    }

    private func run<Seq: Sequence>(on sequense: Seq,
                                    count: Int,
                                    check: (_ index: Int, _ element: Seq.Element?) -> Void) where Seq.Element: Equatable {
        var iterator = sequense.makeIterator()
        for i in 0..<count {
            check(i, iterator.next())
        }
    }

    func testSequenseWithoutElements() {
        run(on: EndlessSequence(elements: [Int]()), count: 10) { (_, value) in
            XCTAssertNil(value)
        }
    }

    func testSequenseWithSingleElement() {
        let expected = "test"
        run(on: EndlessSequence(elements: [expected]), count: 10) { (_, value) in
            checkEqual(value: value, with: expected)
        }
    }

    func testSequenseWithTwoElements() {
        let elements: [Character] = ["a", "z"]
        run(on: EndlessSequence(elements: elements), count: 10) { (i, value) in
            checkEqual(value: value, with: i % 2 == 0 ? elements[0] : elements[1])
        }
    }

    func testTwoIdenticalSequenses() {
        let elements = [1, 1, 2, 3, 5, 8]
        let other = EndlessSequence(elements: elements)
        var otherIterator = other.makeIterator()
        run(on: EndlessSequence(elements: elements), count: 10) { (_, value) in
            let otherValue = otherIterator.next()
            XCTAssertNotNil(otherValue)
            checkEqual(value: value, with: otherValue!)
        }
    }
}
