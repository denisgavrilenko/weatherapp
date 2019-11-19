//
//  ImageProvider.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/19/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func image(for key: String, scale: Int) -> UIImage?
}
