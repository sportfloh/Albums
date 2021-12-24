//
//  AlbumsTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 23.12.21.
//

@testable import Albums
import XCTest

final class AlbumsTests: XCTestCase {}

// swiftlint:disable identifier_name

func DataTestDouble() -> Data {
    Data(UInt8.min ... UInt8.max)
}

func HTTPURLResponseTestDouble(
    statusCode: Int = 200,
    headerFields: [String: String]? = nil
) -> HTTPURLResponse {
    HTTPURLResponse(
        url: URLTestDouble(),
        statusCode: statusCode,
        httpVersion: "HTTP/1.1",
        headerFields: headerFields
    )!
}

func NSErrorTestDouble() -> NSError {
    NSError(domain: "", code: 0)
}

func URLRequestTestData() -> URLRequest {
    URLRequest(url: URLTestDouble())
}

func URLResponseTestDouble() -> URLResponse {
    URLResponse(
        url: URLTestDouble(),
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil
    )
}

func URLTestDouble() -> URL {
    URL(string: "http://localhost/")!
}
