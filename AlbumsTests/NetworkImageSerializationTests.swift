//
//  NetworkImageSerializationTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 28.12.21.
//

@testable import Albums
import XCTest

final class NetworkImageSerializationTestCase: XCTestCase {
    private typealias NetworkImageSerializationTestDouble = NetworkImageSerialization<ImageSourceTestDouble>

    override func tearDown() {
        ImageSourceTestDouble.imageSourceParameterData = nil
        ImageSourceTestDouble.imageSourceParameterOptions = nil
        ImageSourceTestDouble.imageSourceReturnImageSource = nil

        ImageSourceTestDouble.imageParameterImageSource = nil
        ImageSourceTestDouble.imageParameterIndex = nil
        ImageSourceTestDouble.imageParameterOptions = nil
        ImageSourceTestDouble.imageReturnImage = nil
    }
}

extension NetworkImageSerializationTestCase {
    private struct ImageSourceTestDouble: NetworkImageSerializationImageSource {
        static var imageSourceParameterData: CFData?
        static var imageSourceParameterOptions: CFDictionary?
        static var imageSourceReturnImageSource: NSObject?

        static func createImageSource(
            with data: CFData,
            options: CFDictionary?
        ) -> NSObject? {
            self.imageSourceParameterData = data
            self.imageSourceParameterOptions = options
            return self.imageSourceReturnImageSource
        }

        static var imageParameterImageSource: NSObject?
        static var imageParameterIndex: Int?
        static var imageParameterOptions: CFDictionary?
        static var imageReturnImage: NSObject?

        static func createImage(
            with imageSource: NSObject,
            at index: Int,
            options: CFDictionary?
        ) -> NSObject? {
            self.imageParameterImageSource = imageSource
            self.imageParameterIndex = index
            self.imageParameterOptions = options
            return self.imageReturnImage
        }
    }
}

extension NetworkImageSerializationTestCase {
    func testImageSourceError() {
        ImageSourceTestDouble.imageSourceReturnImageSource = nil

        ImageSourceTestDouble.imageReturnImage = nil

        XCTAssertThrowsError(
            try NetworkImageSerializationTestDouble.image(with: DataTestDouble())
        ) { error in
            XCTAssertEqual(
                ImageSourceTestDouble.imageSourceParameterData as Data?,
                DataTestDouble()
            )
            XCTAssertNil(ImageSourceTestDouble.imageSourceParameterOptions)

            XCTAssertNil(ImageSourceTestDouble.imageParameterImageSource)
            XCTAssertNil(ImageSourceTestDouble.imageParameterIndex)
            XCTAssertNil(ImageSourceTestDouble.imageParameterOptions)

            if let error = try? XCTUnwrap(error as? NetworkImageSerializationTestDouble.Error) {
                XCTAssertEqual(error.code, .imageSourceError)
                XCTAssertNil(error.underlying)
            }
        }
    }
}
