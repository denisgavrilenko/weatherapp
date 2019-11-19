//
//  Weather.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import Foundation

protocol WeatherModel {
    func loadNextProvider(completion: @escaping ([Weather.Forecast]) -> ())
}

extension Weather {
    class Weather<Services: Sequence>: WeatherModel where Services.Element == ForecastService {
        private var services: Services.Iterator

        init(services: Services) {
            self.services = services.makeIterator()
        }

        func loadNextProvider(completion: @escaping ([Forecast]) -> ()) {
            guard let service = services.next() else {
                completion([Forecast]())
                return
            }
            service.forecast { result in
                switch result {
                case .failure(let error):
                    print(error)
                    completion([Forecast]())
                case .success(let forecast):
                    completion(forecast)
                }
            }
        }
    }
}
