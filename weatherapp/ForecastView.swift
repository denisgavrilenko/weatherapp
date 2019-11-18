//
//  ForecastView.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class ForecastView: UIView, NibBasedView {
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func set(model: ForecastViewModel) {
        temperatureLabel.text = model.temperature
        timeLabel.text = model.time
        dateLabel.text = model.date
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let icon = model.icon() else { return }
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.iconImageView.image = icon
            }
        }
    }
}
