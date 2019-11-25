//
//  WeatherTests.swift
//  weatherappTests
//
//  Created by Denis Gavrilenko on 11/25/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import XCTest

class WeatherTests: XCTestCase {
    typealias ForecastResult = Result<[Weather.Forecast], Service.Error>
    class ForecastServiceMock: ForecastService {
        private let result: ForecastResult

        init(result: ForecastResult) {
            self.result = result
        }

        func forecast(completion: @escaping (ForecastResult) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completion(self.result)
            }
        }
    }

    private let testForecasts = [Weather.Forecast(temperature: 1.0, date: Date(), imagePath: "test")]

    private func testWeather(for forecasts: [ForecastResult], expectation: XCTestExpectation) {
        let weather = Weather.Weather(services: forecasts.map { ForecastServiceMock(result: $0) })
        forecasts.forEach { toCheck in
            weather.loadNextProvider { forecast in
                if case let .success(forecastToCheck) = toCheck {
                    XCTAssertEqual(forecastToCheck, forecast)
                } else {
                    XCTAssertEqual([Weather.Forecast](), forecast)
                }
                expectation.fulfill()
            }
        }
    }

    func testWeatherWithoutForecast() {
        let exp = expectation(description: "empty forecast")
        Weather.Weather(services: []).loadNextProvider { forecast in
            XCTAssert(forecast.isEmpty)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0)
    }

    func testWeatherWithOneForecast() {
        let exp = expectation(description: "forecast")
        testWeather(for: [.success(testForecasts)], expectation: exp)
        waitForExpectations(timeout: 5.0)
    }

    func testWeatherWithTwoForecasts() {
        let exp = expectation(description: "forecasts")
        exp.expectedFulfillmentCount = 2
        testWeather(for: [.success(testForecasts), .success(testForecasts)], expectation: exp)
        waitForExpectations(timeout: 5.0)
    }

    func testWeatherWithError() {
        let exp = expectation(description: "error")
        testWeather(for: [.failure(.network)], expectation: exp)
        waitForExpectations(timeout: 5.0)
    }

    func testWeatherWithForecastAndError() {
        let exp = expectation(description: "forecast + error")
        exp.expectedFulfillmentCount = 2
        testWeather(for: [.success(testForecasts), .failure(.responseFormat)], expectation: exp)
        waitForExpectations(timeout: 5.0)
    }

    func testWeatherWithForecastAfterError() {
        let exp = expectation(description: "error + forecast")
        exp.expectedFulfillmentCount = 2
        testWeather(for: [.failure(.responseFormat), .success(testForecasts)], expectation: exp)
        waitForExpectations(timeout: 5.0)
    }
}
