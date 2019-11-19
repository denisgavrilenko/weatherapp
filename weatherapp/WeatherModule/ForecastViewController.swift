//
//  ForecastViewController.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    typealias Forecasts = [ForecastViewModel]
    typealias DataSource = Weather.WeatherDataSource<Forecasts, DayForecastTableViewCell>
    @IBOutlet weak var tableView: UITableView!
    private let model: WeatherModel
    private let images: ImageProvider
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

    init(model: WeatherModel, images: ImageProvider) {
        self.model = model
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DayForecastTableViewCell.nib, forCellReuseIdentifier: DayForecastTableViewCell.id)

        let leftButton = UIBarButtonItem(title: "Next",
                                         style: .plain,
                                         target: self,
                                         action: #selector(onChangeService(_:)))
        self.navigationItem.rightBarButtonItem  = leftButton
    }

    private func reloadData(_ viewModels: [[ForecastViewModel]]) {
        dataSource = DataSource(items: viewModels, cellID: DayForecastTableViewCell.id) { (cell, item) in
            cell.set(day: item)
        }
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func loadNextForecast() {
        model.loadNextProvider { [weak self] result in
            guard let self = self else { return }
            let viewModels = result.map { cast in
                ForecastViewModel(cast,
                                  timeFormatter: self.timeFormatter,
                                  dateFormatter: self.dateFormatter,
                                  imageProvider: self.images)
            }.splitBy { (first, second) -> Bool in
                first.date != second.date
            }
            DispatchQueue.main.async {
                self.reloadData(viewModels)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNextForecast()
    }

    @IBAction func onChangeService(_ sender: UIBarButtonItem) {
        loadNextForecast()
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

