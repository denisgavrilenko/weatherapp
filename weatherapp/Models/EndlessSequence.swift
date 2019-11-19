//
//  EndlessSequence.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

struct EndlessSequence<T>: Sequence, IteratorProtocol {
    typealias Element = T

    private let elements: [Element]
    private var index = -1

    init(elements: [Element]) {
        self.elements  = elements
    }

    mutating func next() -> T? {
        guard !elements.isEmpty else { return nil }
        index += 1
        if index == elements.count {
            index = 0
        }
        return elements[index]
    }
}

