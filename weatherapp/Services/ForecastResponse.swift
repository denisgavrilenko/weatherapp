//
//  ForecastResponse.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

extension Service {
    struct ForecastResponse: Codable {
        struct Forecast: Codable {
            struct Main: Codable {
                let temp: Float
            }

            struct Weather: Codable {
                let icon: String
            }

            let dt: Int
            let main: Main
            let weather: [Weather]
        }

        let list: [Forecast]

        var toForecast: [Weather.Forecast] {
            return list.sorted {
                $0.dt < $1.dt
            }.map { value in
                Weather.Forecast(temperature: value.main.temp,
                                 date: Date(timeIntervalSince1970: TimeInterval(value.dt)),
                                 imagePath: value.weather.first!.icon)
            }
        }
    }
}
