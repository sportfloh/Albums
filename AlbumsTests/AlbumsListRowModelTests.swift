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

// MARK: -

extension AlbumsListRowModelTestCase {
    private static var album: Album {
        Album(id: "id", artist: "artist", name: "name", image: "image")
    }

    @MainActor func testError() async {
        ImageOperationTestDouble.returnImage = nil

        let model = AlbumsListRowModelTestDouble(album: Self.album)
        XCTAssertEqual(model.artist, Self.album.artist)
        XCTAssertEqual(model.name, Self.album.name)

        do {
            try await model.requestImage()
            XCTFail("testError failed")
        } catch {
            XCTAssertEqual(
                ImageOperationTestDouble.parameterRequest,
                URLRequest(url: URL(string: Self.album.image)!)
            )

            XCTAssertNil(model.image)

            if let error = try? XCTUnwrap(error as NSError?) {
                XCTAssertIdentical(error, ImageOperationTestDouble.returnError)
            }
        }
    }
}

// MARK: -

extension AlbumsListRowModelTestCase {
    @MainActor func testSuccess() async {
        ImageOperationTestDouble.returnImage = NSObject()

        let model = AlbumsListRowModelTestDouble(album: Self.album)

        var modelDidChange = false
        let modelWillChange = model.objectWillChange.sink { _ in
            modelDidChange = true
        }

        var imageDidChange = false
        let imageWillChange = model.$image.sink { _ in
            if modelDidChange {
                imageDidChange = true
            }
        }

        XCTAssertEqual(model.artist, Self.album.artist)
        XCTAssertEqual(model.name, Self.album.name)

        do {
            try await model.requestImage()

            XCTAssertTrue(imageDidChange)

            XCTAssertEqual(
                ImageOperationTestDouble.parameterRequest,
                URLRequest(url: URL(string: Self.album.image)!)
            )

            XCTAssertIdentical(model.image, ImageOperationTestDouble.returnImage)
        } catch {
            XCTFail("testSuccess failed")
        }

        modelWillChange.cancel()
        imageWillChange.cancel()
    }
}
