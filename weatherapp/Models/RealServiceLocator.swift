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
        lazy var forecast: ForecastService = {
            Service.OpenWeather()
        }()
        lazy var images: ImageProvider = {
            CacheImageProvider(service: forecast)
        }()
    }
}
