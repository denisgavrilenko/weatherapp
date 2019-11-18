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
    private var services = [WeatherServiceLocator]()
    private var index = 0
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

    private func update(with forecasts: [Weather.Forecast], images: ImageProvider) {
        let viewModels = forecasts.map { cast in
            ForecastViewModel(cast,
                              timeFormatter: timeFormatter,
                              dateFormatter: dateFormatter,
                              imageProvider: images)
        }.splitBy { (first, second) -> Bool in
            first.date != second.date
        }

        dataSource = DataSource(items: viewModels, cellID: "day_forecast_cell") { (cell, item) in
            cell.set(day: item)
        }
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func loadForecasts(with service: WeatherServiceLocator) {
        service.forecast.forecast { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let forecast):
                    self.update(with: forecast, images: service.images)
                }
            }
        }
    }

    func set(services: [WeatherServiceLocator]) {
        precondition(!services.isEmpty)

        self.services = services
        loadForecasts(with: services.first!)
        index = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func onChangeService(_ sender: UIBarButtonItem) {
        index += 1
        if index == services.count {
            index = 0
        }
        loadForecasts(with: services[index])
    }
}

fileprivate extension Array {
    func splitBy(closure: (Element, Element) -> Bool) -> [[Element]] {
        guard !isEmpty else { return [[Element]]() }
        var prev = first!
        var next = [Element]()
        var res = reduce(into: [[Element]]()) { (res, elem) in
            if closure(prev, elem) {
                res.append(next)
                next = [elem]
            } else {
                next.append(elem)
            }
            prev = elem
        }
        if !next.isEmpty {
            res.append(next)
        }
        return res
    }
}

