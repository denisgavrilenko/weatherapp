//
//  CacheImageProvider.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol ImageCache {
    func getImage(for key: String) -> UIImage?
    func setImage(_ image: UIImage, for key: String)
}

extension Weather {
    class CacheImageProvider: ImageProvider {
        private let cache: ImageCache
        private let service: ImageService

        init(service: ImageService, cache: ImageCache = StandartImageCache()) {
            self.service =  service
            self.cache = cache
        }

        func image(for key: String, scale: Int) -> UIImage? {
            if let image = cache.getImage(for: key) {
                return image
            }

            var image: UIImage?
            let semaphore = DispatchSemaphore(value: 0)
            let cache = self.cache
            service.image(for: key, scale: scale) { result in
                if case let .success(resultImage) = result {
                    cache.setImage(resultImage, for: key)
                    image = resultImage
                }
                semaphore.signal()
            }
            semaphore.wait()
            return image
        }
    }
}
