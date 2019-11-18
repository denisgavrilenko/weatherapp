//
//  StandartImageCache.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class StandartImageCache: ImageCache {
    private let cache = NSCache<NSString, UIImage>()

    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
