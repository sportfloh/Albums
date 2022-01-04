//
//  NetworkSessionTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 04.01.22.
//

import XCTest

// MARK: -

final class NetworkSessionTestCase: XCTestCase {
    override func tearDown() {
        URLSessionTestDouble.shared.parameterRequest = nil
        URLSessionTestDouble.shared.parameterDelegate = nil
        URLSessionTestDouble.shared.returnData = nil
        URLSessionTestDouble.shared.returnResponse = nil
    }
}

// MARK: - Test Doubles

extension NetworkSessionTestCase {
    private typealias NetworkSessionTestDouble = NetworkSession<URLSessionTestDouble>

    private final class URLSessionTestDouble: NetworkSessionURLSession {
        static let shared = URLSessionTestDouble()

        var parameterRequest: URLRequest?
        weak var parameterDelegate: URLSessionTaskDelegate?
        var returnData: Data?
        var returnResponse: URLResponse?
        let returnError = NSErrorTestDouble()

        func data(
            for request: URLRequest,
            delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
            self.parameterRequest = request
            self.parameterDelegate = delegate
            guard
                let returnData = self.returnData,
                let returnResponse = self.returnResponse
            else {
                throw self.returnError
            }
            return (returnData, returnResponse)
        }
    }
}

// MARK: -

extension NetworkSessionTestCase {
    func testError() async {
        URLSessionTestDouble.shared.returnData = nil
        URLSessionTestDouble.shared.returnResponse = nil

        do {
            _ = try await NetworkSessionTestDouble.data(for: URLRequestTestData())
            XCTFail("NetworkSessionTestDouble failed")
        } catch {
            XCTAssertEqual(
                URLSessionTestDouble.shared.parameterRequest,
                URLRequestTestData())
            XCTAssertNil(URLSessionTestDouble.shared.parameterDelegate)

            if let error = try? XCTUnwrap(error as NSError?) {
                XCTAssertIdentical(error, URLSessionTestDouble.shared.returnError)
            }
        }
    }
}

// MARK: -

extension NetworkSessionTestCase {
    func testSuccess() async {
        URLSessionTestDouble.shared.returnData = DataTestDouble()
        URLSessionTestDouble.shared.returnResponse = HTTPURLResponseTestDouble()

        do {
            let (data, response) = try await NetworkSessionTestDouble.data(for: URLRequestTestData())

            XCTAssertEqual(
                URLSessionTestDouble.shared.parameterRequest,
                URLRequestTestData())
            XCTAssertNil(URLSessionTestDouble.shared.parameterDelegate)

            XCTAssertEqual(
                data,
                URLSessionTestDouble.shared.returnData)
            XCTAssertIdentical(
                response, URLSessionTestDouble.shared.returnResponse)
        } catch {
            XCTFail("testSuccess not successfull")
        }
    }
}
