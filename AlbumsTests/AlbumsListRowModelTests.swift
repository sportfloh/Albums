//
//  AlbumsListRowModelTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 08.01.22.
//

@testable import Albums
import Foundation
import XCTest

// MARK: -

final class AlbumsListRowModelTestCase: XCTestCase {
    override class func tearDown() {
        ImageOperationTestDouble.parameterRequest = nil
        ImageOperationTestDouble.returnImage = nil
    }
}

// MARK: - Test Doubles

extension AlbumsListRowModelTestCase {
    private typealias AlbumsListRowModelTestDouble = AlbumsListRowModel<ImageOperationTestDouble>

    private struct ImageOperationTestDouble: AlbumsListRowModelsImageOperation {
        static var parameterRequest: URLRequest?
        static var returnImage: NSObject?
        static var returnError = NSErrorTestDouble()

        static func image(for request: URLRequest) async throws -> NSObject {
            self.parameterRequest = request
            guard let returnImage = self.returnImage else {
                throw self.returnError
            }
            return returnImage
        }
    }
}

