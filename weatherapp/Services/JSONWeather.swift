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
        func forecast(completion: @escaping (Result<[Weather.Forecast], Service.Error>) -> Void) {
            guard let url = Bundle.main.url(forResource: "static", withExtension: "json") else {
                completion(.failure(.responseFormat))
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(response.toForecast))
            } catch {
                completion(.failure(.responseFormat))
            }
        }

        func image(for imagePath: String, scale: Int, completion: @escaping (Result<UIImage, Service.Error>) -> Void) {
            
        }
    }
}
