//
//  ForecastService.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

enum Service {
    enum Error: Swift.Error {
        case network, responseFormat
    }
}

protocol ForecastService: ImageService {
    func forecast(completion: @escaping (Result<[Weather.Forecast], Service.Error>) -> Void)
}
