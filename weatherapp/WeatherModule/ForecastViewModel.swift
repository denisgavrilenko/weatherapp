//
//  ForecastViewModel.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    let temperature: String
    let time: String
    let date: String
    let icon: () -> UIImage?
}

extension ForecastViewModel {
    init(_ forecast: Weather.Forecast,
         timeFormatter: DateFormatter,
         dateFormatter: DateFormatter,
         imageProvider: ImageProvider,
         scale: Int = 2) {
        self.temperature = String(forecast.temperature)
        self.time = timeFormatter.string(from: forecast.date)
        self.date = dateFormatter.string(from: forecast.date)
        self.icon = { imageProvider.image(for: forecast.imagePath, scale: scale) }
    }
}
