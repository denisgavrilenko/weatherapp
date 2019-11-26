//
//  CacheImageProviderTests.swift
//  weatherappTests
//
//  Created by Denis Gavrilenko on 11/26/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import XCTest

class CacheImageProviderTests: XCTestCase {
    typealias ImageResult = Result<UIImage, Service.Error>
    class ImageServiceMock: ImageService {
        var wasCalled = false
        private let result: ImageResult

        init(result: ImageResult) {
            self.result = result
        }

        func image(for imagePath: String, scale: Int, completion: @escaping (ImageResult) -> Void) {
            wasCalled = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                completion(self.result)
            }
        }
    }

    class ImageCacheMock: ImageCache {
        let result: UIImage?
        var imageSetted = false

        init(result: UIImage?) {
            self.result = result
        }

        func getImage(for key: String) -> UIImage? {
            result
        }

        func setImage(_ image: UIImage, for key: String) {
            imageSetted = true
        }
    }

    private let key = "test_key"

    private let image: UIImage = {
        let path = Bundle(for: StandartImageCacheTests.self).path(forResource: "test", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }()

    func testNotCachedSuccessfulLoad() {
        let cache = ImageCacheMock(result: nil)
        let sut = Weather.CacheImageProvider(service: ImageServiceMock(result: .success(image)), cache: cache)

        let result = sut.image(for: key, scale: 2)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, image)
        XCTAssert(cache.imageSetted)
    }

    func testCachedSuccessfulLoad() {
        let cache = ImageCacheMock(result: image)
        let service = ImageServiceMock(result: .failure(.network))
        let sut = Weather.CacheImageProvider(service: service, cache: cache)

        let result = sut.image(for: key, scale: 2)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, image)
        XCTAssertFalse(cache.imageSetted)
        XCTAssertFalse(service.wasCalled)
    }

    func testNotCachedFailedLoad() {
        let cache = ImageCacheMock(result: nil)
        let service = ImageServiceMock(result: .failure(.network))
        let sut = Weather.CacheImageProvider(service: service, cache: cache)

        let result = sut.image(for: key, scale: 2)
        XCTAssertNil(result)
        XCTAssertFalse(cache.imageSetted)
        XCTAssert(service.wasCalled)
    }
}
