//
//  HasID.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol HasID {
    static var id: String { get }
}

extension HasID where Self: UITableViewCell {
    static var id: String {
        "\(self)".lowercased()
    }
}
