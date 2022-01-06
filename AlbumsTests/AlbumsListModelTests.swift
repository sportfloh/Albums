//
//  AlbumsListModelTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 06.01.22.
//

@testable import Albums
import XCTest

// MARK: -

final class AlbumsListModelTestCase: XCTestCase {
    override func tearDown() {
        JSONOperationTestDouble.parameterRequest = nil
        JSONOperationTestDouble.returnJSON = nil
    }
}

// MARK: - Test Doubles

extension AlbumsListModelTestCase {
    private typealias AlbumsListModelTestDouble = AlbumsListModel<JSONOperationTestDouble>

    private struct JSONOperationTestDouble: AlbumsListModelJSONOperation {
        static var parameterRequest: URLRequest?
        static var returnJSON: Any?
        static let returnError = NSErrorTestDouble()

        static func json(for request: URLRequest) async throws -> Any {
            self.parameterRequest = request
            guard let returnJSON = self.returnJSON else {
                throw self.returnError
            }
            return returnJSON
        }
    }
}

// MARK: -

extension AlbumsListModelTestCase {
    private static var request: URLRequest {
        URLRequest(url: URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=100/json")!)
    }

    @MainActor func testError() async {
        JSONOperationTestDouble.returnJSON = nil

        let model = AlbumsListModelTestDouble()
        do {
            try await model.requestAlbums()
            XCTFail("testError failed")
        } catch {
            XCTAssertEqual(JSONOperationTestDouble.parameterRequest, Self.request)

            XCTAssertEqual(model.albums, [])

            if let error = try? XCTUnwrap(error as NSError?) {
                XCTAssertIdentical(error, JSONOperationTestDouble.returnError)
            }
        }
    }
}
