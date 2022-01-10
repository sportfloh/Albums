//
//  NetworkImageHandlerTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 29.12.21.
//

// swiftlint:disable line_length

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
    private typealias NetworkImageHandlerTestDouble = NetworkImageHandler<DataHandlerTestDouble, ImageSerializationTestDouble>

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

// MARK: -

extension NetworkImageHandlerTestCase {
    func testMimeTypeError() {
        DataHandlerTestDouble.returnData = nil

        ImageSerializationTestDouble.returnImage = nil

        let response = HTTPURLResponseTestDouble(headerFields: ["CONTENT-TYPE": "TEXT/JAVASCRIPT"])

        XCTAssertThrowsError(
            try NetworkImageHandlerTestDouble.image(
                with: DataTestDouble(),
                response: response
            )
        ) { error in
            XCTAssertNil(DataHandlerTestDouble.parameterData)
            XCTAssertNil(DataHandlerTestDouble.parameterResponse)

            XCTAssertNil(ImageSerializationTestDouble.parameterData)

            if let error = try? XCTUnwrap(error as? NetworkImageHandlerTestDouble.Error) {
                XCTAssertEqual(error.code, .mimeTypeError)
                XCTAssertNil(error.underlying)
            }
        }
    }
}

// MARK: -

extension NetworkImageHandlerTestCase {
    func testDatahandlerError() {
        DataHandlerTestDouble.returnData = nil

        ImageSerializationTestDouble.returnImage = nil

        let response = HTTPURLResponseTestDouble(headerFields: ["CONTENT-TYPE": "IMAGE/PNG"])

        XCTAssertThrowsError(
            try NetworkImageHandlerTestDouble.image(
                with: DataTestDouble(),
                response: response
            )
        ) { error in
            XCTAssertEqual(DataHandlerTestDouble.parameterData, DataTestDouble())
            XCTAssertIdentical(DataHandlerTestDouble.parameterResponse, response)

            XCTAssertNil(ImageSerializationTestDouble.parameterData)

            if let error = try? XCTUnwrap(error as? NetworkImageHandlerTestDouble.Error) {
                XCTAssertEqual(error.code, .dataHandlerError)
                if let underlying = try? XCTUnwrap(error.underlying as NSError?) {
                    XCTAssertIdentical(underlying, DataHandlerTestDouble.returnError)
                }
            }
        }
    }
}

// MARK: -

extension NetworkImageHandlerTestCase {
    func testImageSerializationError() {
        DataHandlerTestDouble.returnData = DataTestDouble()

        ImageSerializationTestDouble.returnImage = nil

        let response = HTTPURLResponseTestDouble(headerFields: ["CONTENT-TYPE": "IMAGE/PNG"])

        XCTAssertThrowsError(
            try NetworkImageHandlerTestDouble.image(
                with: DataTestDouble(),
                response: response
            )
        ) { error in
            XCTAssertEqual(
                DataHandlerTestDouble.parameterData,
                DataTestDouble()
            )
            XCTAssertIdentical(
                DataHandlerTestDouble.parameterResponse,
                response
            )

            XCTAssertEqual(
                ImageSerializationTestDouble.parameterData,
                DataHandlerTestDouble.returnData
            )

            if let error = try? XCTUnwrap(error as? NetworkImageHandlerTestDouble.Error) {
                XCTAssertEqual(error.code, .imageSerializationError)
                if let underlying = try? XCTUnwrap(error.underlying as NSError?) {
                    XCTAssertIdentical(underlying, ImageSerializationTestDouble.returnError)
                }
            }
        }
    }
}

// MARK: -

extension NetworkImageHandlerTestCase {
    func testSuccess() {
        DataHandlerTestDouble.returnData = DataTestDouble()

        ImageSerializationTestDouble.returnImage = NSObject()

        let response = HTTPURLResponseTestDouble(headerFields: ["CONTENT-TYPE": "IMAGE/PNG"])

        XCTAssertNoThrow(
            try {
                let image = try NetworkImageHandlerTestDouble.image(
                    with: DataTestDouble(),
                    response: response
                )

                XCTAssertEqual(DataHandlerTestDouble.parameterData, DataTestDouble())
                XCTAssertIdentical(DataHandlerTestDouble.parameterResponse, response)

                XCTAssertEqual(
                    ImageSerializationTestDouble.parameterData,
                    DataHandlerTestDouble.returnData
                )

                XCTAssertIdentical(image, ImageSerializationTestDouble.returnImage)
            }()
        )
    }
}
