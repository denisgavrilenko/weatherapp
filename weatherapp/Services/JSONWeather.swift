//
//  JSONWeather.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

extension Service {
    class JSONService: ForecastService {
        private let fileURL: URL

        init(fileURL: URL) {
            self.fileURL = fileURL
        }

        func forecast(completion: @escaping (Result<[Weather.Forecast], Service.Error>) -> Void) {
            do {
                let data = try Data(contentsOf: fileURL)
                let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(response.toForecast))
            } catch {
                completion(.failure(.responseFormat))
            }
        }
    }
}
