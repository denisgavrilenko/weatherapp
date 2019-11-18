//
//  WeatherViewController.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func image(for key: String, scale: Int) -> UIImage?
}

class WeatherViewController: UITableViewController {
    private var service: ForecastService!
    private var imageProvider: ImageProvider!
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
                                  imageProvider: imageProvider)
            }
        }
        tableView.reloadData()
    }

    private func loadForecast() {
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

    func set(service: ForecastService, imageProvider: ImageProvider) {
        self.service = service
        self.imageProvider = imageProvider
        self.loadForecast()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

