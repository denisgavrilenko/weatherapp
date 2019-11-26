//
//  StandartImageCacheTests.swift
//  weatherappTests
//
//  Created by Denis Gavrilenko on 11/26/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import XCTest

class StandartImageCacheTests: XCTestCase {
    private let sut = Weather.StandartImageCache()
    private let key = "test_key"
    private let otherKey = "other_test_key"
    private let image: UIImage = {
        let path = Bundle(for: StandartImageCacheTests.self).path(forResource: "test", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }()
    private let otherImage: UIImage = {
        let path = Bundle(for: StandartImageCacheTests.self).path(forResource: "other", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }()

    override func setUp() {
        sut.reset()
    }

    private func runTest(for keys: [String], checkup: [UIImage]) {
        zip(keys, checkup).forEach { (key, image) in
            let cached = sut.getImage(for: key)
            XCTAssertNotNil(cached)
            XCTAssertEqual(cached!, image)
        }
    }

    func testNoCachedImage() {
        XCTAssertNil(sut.getImage(for: key))
    }

    func testCacheOneImage() {
        sut.setImage(image, for: key)
        runTest(for: [key], checkup: [image])
    }

    func testCacheTwoImages() {
        sut.setImage(image, for: key)
        sut.setImage(otherImage, for: otherKey)
        runTest(for: [key, otherKey], checkup: [image,  otherImage])
    }

    func testCacheOverriding() {
        sut.setImage(image, for: key)
        runTest(for: [key], checkup: [image])
        sut.setImage(otherImage, for: key)
        runTest(for: [key], checkup: [otherImage])
    }

    func testCacheReset() {
        XCTAssertNil(sut.getImage(for: key))
        sut.setImage(image, for: key)
        XCTAssertNotNil(sut.getImage(for: key))
        sut.reset()
        XCTAssertNil(sut.getImage(for: key))
    }
}
