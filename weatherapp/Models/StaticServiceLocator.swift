//
//  StaticServiceLocator.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

extension Weather {
    class StaticServiceLocator: WeatherServiceLocator {
        lazy var forecast: ForecastService = {
            Service.JSONService()
        }()
        lazy var images: ImageProvider = {
            CacheImageProvider(service: Service.OpenWeather(key: "a541f24c3ad30edbf9054f27bb381e90"))
        }()
    }
}
