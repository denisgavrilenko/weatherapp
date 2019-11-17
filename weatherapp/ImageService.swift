//
//  ImageService.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol ImageService {
    func image(for imagePath: String, completion: @escaping (Result<UIImage, Service.Error>) -> Void)
}
