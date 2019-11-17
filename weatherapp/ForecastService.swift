//
//  ForecastService.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

enum Service {
    struct Forecast {
        let temperature: Float
        let date: Date
        let imagePath: String
    }

    struct FiveDayForecast {
        static let numberPerDay = 8
        let days: [[Forecast]]
    }

    enum Error: Swift.Error {
        case network, responseFormat
    }
}

protocol ForecastService: ImageService {
    func forecast(completion: @escaping (Result<Service.FiveDayForecast, Service.Error>) -> Void)
}
