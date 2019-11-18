//
//  WeatherServiceLocator.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

protocol WeatherServiceLocator {
    var forecast: ForecastService { get }
    var images: ImageProvider { get }
}
