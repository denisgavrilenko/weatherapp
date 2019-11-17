//
//  WeatherViewController.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
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
    init(_ forecast: Weather.Forecast, timeFormatter: DateFormatter, dateFormatter: DateFormatter, imageService: ImageService) {
        self.temperature = String(forecast.temperature)
        self.time = timeFormatter.string(from: forecast.date)
        self.date = dateFormatter.string(from: forecast.date)
        self.icon = {
            return nil
//            imageService.image(for: forecast.imagePath, completion: <#T##(Result<UIImage, Service.Error>) -> Void#>)
        }
    }
}

class WeatherViewController: UITableViewController {
    private let service = Service.OpenWeather()
    private var forecast = [[ForecastViewModel]]()
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    private func update(with forecast: Weather.FiveDayForecast) {
        self.forecast = forecast.days.map { day in
            day.map { cast in
                ForecastViewModel(cast,
                                  timeFormatter: timeFormatter,
                                  dateFormatter: dateFormatter,
                                  imageService: service)
            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        service.forecast { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let forecast):
                    self.update(with: forecast)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day_forecast_cell", for: indexPath) as! DayForecastTableViewCell
        cell.set(day: forecast[indexPath.row])
        return cell
    }
}

