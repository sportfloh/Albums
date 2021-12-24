//
//  NetworkDataHandlerTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 23.12.21.
//

@testable import Albums
import XCTest

final class NetworkDataHandlerTests: XCTestCase {
    func testError() {
        XCTAssertThrowsError(
            try NetworkDataHandler.data(
                with: DataTestDouble(),
                response: URLResponseTestDouble()
            )
        )
    }
}
