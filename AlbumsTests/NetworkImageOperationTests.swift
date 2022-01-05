//
//  NetworkImageOperationTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 05.01.22.
//

@testable import Albums
import XCTest

// MARK: -

final class NetworkImageOperationTestCase: XCTestCase {
    override func tearDown() {
        SessionTestDouble.parameterRequest = nil
        SessionTestDouble.returnData = nil
        SessionTestDouble.returnResponse = nil

        ImageHandlerTestDouble.parameterData = nil
        ImageHandlerTestDouble.parameterResponse = nil
        ImageHandlerTestDouble.returnImage = nil
    }
}

// MARK: - Test Doubles

extension NetworkImageOperationTestCase {
    private typealias NetworkImageOperationTestDouble = NetworkImageOperation<SessionTestDouble, ImageHandlerTestDouble>

    private struct SessionTestDouble: NetworkImageOperationSession {
        static var parameterRequest: URLRequest?
        static var returnData: Data?
        static var returnResponse: URLResponse?
        static let returnError = NSErrorTestDouble()

        static func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            self.parameterRequest = request
            guard
                let returnData = self.returnData,
                let returnResponse = self.returnResponse
            else {
                throw self.returnError
            }
            return (returnData, returnResponse)
        }
    }

    private struct ImageHandlerTestDouble: NetworkImageOperationImageHandler {
        static var parameterData: Data?
        static var parameterResponse: URLResponse?
        static var returnImage: NSObject?
        static let returnError = NSErrorTestDouble()

        static func image(with data: Data, response: URLResponse) throws -> NSObject {
            self.parameterData = data
            self.parameterResponse = response
            guard let returnImage = self.returnImage else {
                throw self.returnError
            }
            return returnImage
        }
    }
}
