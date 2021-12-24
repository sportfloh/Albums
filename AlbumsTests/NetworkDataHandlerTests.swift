//
//  NetworkDataHandlerTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 23.12.21.
//

@testable import Albums
import XCTest

final class NetworkDataHandlerTestCase: XCTestCase {}

extension NetworkDataHandlerTestCase {
    func testError() {
        XCTAssertThrowsError(
            try NetworkDataHandler.data(
                with: DataTestDouble(),
                response: URLResponseTestDouble()
            )
        ) { error in
            if let error = try? XCTUnwrap(error as? NetworkDataHandler.Error) {
                XCTAssertEqual(error.code, .statusCodeError)
                XCTAssertNil(error.underlying)
            }
        }
    }
}

extension NetworkDataHandlerTestCase {
    private static var errorCodes: [Int] {
        Array(100 ... 199) + Array(300 ... 599)
    }

    func testErrorWithStatusCode() {
        for statusCode in Self.errorCodes {
            XCTAssertThrowsError(
                try NetworkDataHandler.data(
                    with: DataTestDouble(),
                    response: HTTPURLResponseTestDouble(statusCode: statusCode)
                ),
                "Status Code \(statusCode)"
            ) { error in
                if let error = try? XCTUnwrap(
                    error as? NetworkDataHandler.Error,
                    "Status Code \(statusCode)"
                ) {
                    XCTAssertEqual(
                        error.code,
                        .statusCodeError,
                        "Status Code \(statusCode)"
                    )
                    XCTAssertNil(error.underlying, "Status Code \(statusCode)")
                }
            }
        }
    }
}

extension NetworkDataHandlerTestCase {
    private static var successCodes: [Int] {
        Array(200 ... 299)
    }

    func testSuccess() {
        for statusCode in Self.successCodes {
            XCTAssertNoThrow(
                try {
                    let data = try NetworkDataHandler.data(
                        with: DataTestDouble(),
                        response: HTTPURLResponseTestDouble(statusCode: statusCode)
                    )
                    XCTAssertEqual(
                        data,
                        DataTestDouble(),
                        "Status Code \(statusCode)"
                    )
                }(),
                "Status Code \(statusCode)"
            )
        }
    }
}
