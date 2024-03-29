//
//  DIContainer.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class DIContainer {
    private lazy var realService: ForecastService & ImageService = {
        Service.OpenWeather(key: "a541f24c3ad30edbf9054f27bb381e90")
    }()
    private lazy var imagesProvider: ImageProvider = {
        Weather.CacheImageProvider(service: realService)
    }()

    func forecast() -> UIViewController {
        let file = Bundle.main.url(forResource: "static", withExtension: "json")
        precondition(file != nil, "Please, include static.json in bundle")
        let staticSetvice = Service.JSONService(fileURL: file!)
        let weatherServices = EndlessSequence<ForecastService>(elements: [realService, staticSetvice])
        let model = Weather.Weather(services: weatherServices)
        return ForecastViewController(model: model, images: imagesProvider)
    }
}
