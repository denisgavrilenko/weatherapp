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
    typealias Forecasts = [ForecastViewModel]
    typealias DataSource = Weather.WeatherDataSource<Forecasts, DayForecastTableViewCell>
    private var serviceLocator: WeatherServiceLocator!
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
    private var dataSource: DataSource?

    private func update(with forecast: Weather.FiveDayForecast) {
        let forecasts = forecast.days.map { day in
            day.map { cast in
                ForecastViewModel(cast,
                                  timeFormatter: timeFormatter,
                                  dateFormatter: dateFormatter,
                                  imageProvider: serviceLocator.images)
            }
        }
        dataSource = DataSource(items: forecasts, cellID: "day_forecast_cell") { (cell, item) in
            cell.set(day: item)
        }
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func loadForecasts() {
        serviceLocator.forecast.forecast { [weak self] result in
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

    func set(service: WeatherServiceLocator) {
        self.serviceLocator = service
        loadForecasts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

