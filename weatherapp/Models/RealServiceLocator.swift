//
//  RealServiceLocator.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

extension Weather {
    class RealServiceLocator: WeatherServiceLocator {
        private lazy var realService: ForecastService & ImageService = {
            Service.OpenWeather(key: "a541f24c3ad30edbf9054f27bb381e90")
        }()

        var forecast: ForecastService {
            realService
        }
        lazy var images: ImageProvider = {
            CacheImageProvider(service: realService)
        }()
    }
}
