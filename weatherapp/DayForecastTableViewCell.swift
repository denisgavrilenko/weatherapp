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

    private let numberOfForecasts = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()

        for _ in 0..<numberOfForecasts {
            stackView.addArrangedSubview(ForecastView.instantiateFromNib()!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
