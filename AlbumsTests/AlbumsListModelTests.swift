//
//  AlbumsListModelTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 06.01.22.
//

@testable import Albums
import XCTest

// MARK: -

final class AlbumsListModelTestCase: XCTest {
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
