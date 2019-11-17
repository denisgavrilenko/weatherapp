//
//  Forecast.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

enum Weather {
    struct Forecast {
        let temperature: Float
        let date: Date
        let imagePath: String
    }

    struct FiveDayForecast {
        static let numberPerDay = 8
        let days: [[Forecast]]
    }
}
