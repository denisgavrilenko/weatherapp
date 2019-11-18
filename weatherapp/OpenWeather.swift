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

        private let session = URLSession(configuration: .default)

        func forecast(completion: @escaping (Result<Weather.FiveDayForecast, Service.Error>) -> Void) {
            session.dataTask(with: URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=London,uk&units=metric&APPID=a541f24c3ad30edbf9054f27bb381e90")!) { (data, response, error) in
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

fileprivate extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
