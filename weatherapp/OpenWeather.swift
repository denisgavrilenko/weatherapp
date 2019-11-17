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
                let weather: Weather
            }

            let list: [Forecast]

            var toForecast: Service.FiveDayForecast {
                let forcasts = list.sorted {
                    $0.dt < $1.dt
                }.reduce([Service.Forecast]()) { (res, value) in
                    return res + [Service.Forecast(temperature: value.main.temp,
                                                   date: Date(timeIntervalSince1970: TimeInterval(value.dt)),
                                                   imagePath: value.weather.icon)]
                }.chunked(into: Service.FiveDayForecast.numberPerDay)
                return Service.FiveDayForecast(days: forcasts)
            }
        }

        private let session = URLSession(configuration: .default)

        func forecast(completion: @escaping (Result<Service.FiveDayForecast, Service.Error>) -> Void) {
            session.dataTask(with: URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=a541f24c3ad30edbf9054f27bb381e90")!) { (data, response, error) in
                if let _ = error {
                    completion(.failure(.network))
                    return
                }
                guard let data = data else {
                    completion(.failure(.network))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ForecastResponse.self, from: data)
                    completion(.success(response.toForecast))
                } catch {
                    completion(.failure(.responseFormat))
                }
            }
        }

        func image(for imagePath: String, completion: @escaping (Result<UIImage, Service.Error>) -> Void) {
            session.dataTask(with: URL(string: "https://api.openweathermap.org/img/wn/" + imagePath + "@2x.png")!) { (data, response, error) in
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
            }
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
