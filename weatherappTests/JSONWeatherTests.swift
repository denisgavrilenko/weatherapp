//
//  JSONWeatherTests.swift
//  weatherappTests
//
//  Created by Denis Gavrilenko on 11/26/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import XCTest

class JSONWeatherTests: XCTestCase {
    func testValidJSON() {
        let file = Bundle(for: JSONWeatherTests.self).url(forResource: "static", withExtension: "json")
        XCTAssertNotNil(file)

        let exp = expectation(description: "forecast")
        let sut = Service.JSONService(fileURL: file!)
        sut.forecast { result in
            guard case let .success(forecasts) = result else {
                XCTFail("can't parse json file")
                return
            }
            XCTAssertEqual(forecasts.count, 3)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0)
    }

    func testInvalidJSON() {
        let file = Bundle(for: JSONWeatherTests.self).url(forResource: "invalid", withExtension: "json")
        XCTAssertNotNil(file)

        let exp = expectation(description: "error")
        let sut = Service.JSONService(fileURL: file!)
        sut.forecast { result in
            guard case let .failure(error) = result else {
                XCTFail("it have to be error")
                return
            }
            XCTAssertEqual(error, Service.Error.responseFormat)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0)
    }
}
