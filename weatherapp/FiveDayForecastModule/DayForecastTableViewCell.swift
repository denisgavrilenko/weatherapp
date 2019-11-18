//
//  DayForecastTableViewCell.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    private var forecasts = [ForecastView]()

    private func createArrangedSubiews(count: Int) -> [ForecastView] {
        if forecasts.count == count {
            return forecasts.reversed()
        }
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        forecasts.removeAll()
        for _ in 0..<count {
            let view = ForecastView.instantiateFromNib()!
            forecasts.append(view)
            stackView.addArrangedSubview(view)
        }
        return forecasts.reversed()
    }

    func set(day forecast: [ForecastViewModel]) {
        zip(createArrangedSubiews(count: forecast.count), forecast)
            .forEach { (view, model) in
                view.set(model: model)
            }
    }
}
