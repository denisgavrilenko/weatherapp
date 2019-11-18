//
//  OpenWeather.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

extension Service {
    class OpenWeather: ForecastService {
        enum City: String {
            case london = "London,uk"
            static let key = "q"
            var query: String {
                Self.key + "=" + rawValue
            }
        }

        enum Units: String {
            case metric = "metric"
            static let key = "units"
            var query: String {
                Self.key + "=" + rawValue
            }
        }

        private let session = URLSession(configuration: .default)
        private let city: City
        private let units: Units
        private let key: String

        init(key: String, city: City = .london, units: Units = .metric) {
            self.key = key
            self.city = city
            self.units = units
        }

        func forecast(completion: @escaping (Result<[Weather.Forecast], Service.Error>) -> Void) {
            session.dataTask(with: URL(string: "https://api.openweathermap.org/data/2.5/forecast?" + city.query +
                "&" + units.query + "&APPID=" + key)!) { (data, response, error) in
                if let _ = error {
                    completion(.failure(.network))
                    return
                }
                guard let data = data else {
                    completion(.failure(.network))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    completion(.success(response.toForecast))
                } catch {
                    completion(.failure(.responseFormat))
                }
            }.resume()
        }

        func image(for imagePath: String, scale: Int, completion: @escaping (Result<UIImage, Service.Error>) -> Void) {
            session.dataTask(with: URL(string: "https://openweathermap.org/img/wn/" + imagePath + "@\(scale)x.png")!) { (data, response, error) in
                if let _ = error {
                    completion(.failure(.network))
                    return
                }
                guard let data = data else {
                    completion(.failure(.network))
                    return
                }
                guard let image = UIImage(data: data) else {
                    completion(.failure(.responseFormat))
                    return
                }
                completion(.success(image))
            }.resume()
        }
    }
}
