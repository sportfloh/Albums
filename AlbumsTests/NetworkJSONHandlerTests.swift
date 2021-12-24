//
//  NetworkJSONHandlerTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 24.12.21.
//

@testable import Albums
import XCTest

final class NetworkJSONHandlerTestCase: XCTestCase {}

extension NetworkDataHandlerTestCase {
    func testMimeTypeError() {
        let response = HTTPURLResponseTestDouble(headerFields: ["CONTENT-TYPE": "IMAGE/PNG"])

        XCTAssertThrowsError(
            try NetworkJSONHandler.json(
                with: DataTestDouble(),
                response: response
            )
        ) { error in
            if let error = try? XCTUnwrap(error as? NetworkJSONHandler.Error) {
                XCTAssertEqual(error.code, .mimeTypeError)
                XCTAssertNil(error.underlying)
            }
        }
    }
}
