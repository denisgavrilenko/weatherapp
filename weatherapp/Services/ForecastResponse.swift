//
//  ForecastResponse.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

extension Service.OpenWeather {
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

        var toForecast: Weather.FiveDayForecast {
            let forcasts = list.sorted {
                $0.dt < $1.dt
            }.reduce([Weather.Forecast]()) { (res, value) in
                return res + [Weather.Forecast(temperature: value.main.temp,
                                               date: Date(timeIntervalSince1970: TimeInterval(value.dt)),
                                               imagePath: value.weather.first!.icon)]
            }.chunked(into: Weather.FiveDayForecast.numberPerDay)
            return Weather.FiveDayForecast(days: forcasts)
        }
    }
}

fileprivate extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
