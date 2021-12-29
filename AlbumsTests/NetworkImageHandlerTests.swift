//
//  NetworkImageHandlerTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 29.12.21.
//

@testable import Albums
import XCTest

// MARK: -

final class NetworkImageHandlerTestCase: XCTestCase {
    override func tearDown() {
        DataHandlerTestDouble.parameterData = nil
        DataHandlerTestDouble.parameterResponse = nil
        DataHandlerTestDouble.returnData = nil

        ImageSerializationTestDouble.parameterData = nil
        ImageSerializationTestDouble.returnImage = nil
    }
}

// MARK: - Test Doubles

extension NetworkImageHandlerTestCase {
    private typealias NetworkImageHandlerTestDoubles = NetworkImageHandler<DataHandlerTestDouble, ImageSerializationTestDouble>

    private struct DataHandlerTestDouble: NetworkImageHandlerDataHandler {
        static var parameterData: Data?
        static var parameterResponse: URLResponse?
        static var returnData: Data?
        static let returnError = NSErrorTestDouble()

        static func data(
            with data: Data,
            response: URLResponse
        ) throws -> Data {
            self.parameterData = data
            self.parameterResponse = response
            guard let returnData = self.returnData else {
                throw self.returnError
            }
            return returnData
        }
    }

    private struct ImageSerializationTestDouble: NetworkImageHandlerImageSerialization {
        static var parameterData: Data?
        static var returnImage: NSObject?
        static let returnError = NSErrorTestDouble()

        static func image(with data: Data) throws -> NSObject {
            self.parameterData = data
            guard let returnImage = self.returnImage else {
                throw self.returnError
            }
            return returnImage
        }
    }
}
