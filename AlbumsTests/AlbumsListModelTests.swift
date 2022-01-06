//
//  AlbumsListModelTests.swift
//  AlbumsTests
//
//  Created by Florian Bruder on 06.01.22.
//

// swiftlint:disable identifier_name force_try

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

// MARK: -

private func Albums(_ json: Any) -> [Album] {
    var albums = [Album]()
    if let array = ((json as? [String: Any])?["feed"] as? [String: Any])?["entry"] as? [[String: Any]] {
        for dictionary in array {
            if let artist = ((dictionary["im:artist"] as? [String: Any])?["label"] as? String),
               let name = ((dictionary["im:name"] as? [String: Any])?["label"] as? String),
               let image = ((dictionary["im:image"] as? [[String: Any]])?[2]["label"] as? String),
               let id = (((dictionary["id"] as? [String: Any])?["attributes"] as? [String: Any])?["im:id"] as? String)
            {
                let album = Album(
                    id: id,
                    artist: artist,
                    name: name,
                    image: image
                )
                albums.append(album)
            }
        }
    }
    return albums
}

// MARK: -

extension AlbumsListModelTestCase {
    private static var json: Any {
        let bundle = Bundle(identifier: "de.sportfloh.AlbumsTests")!
        let url = bundle.url(forResource: "Albums", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json
    }

    private static var albums: [Album] {
        Albums(self.json)
    }

    @MainActor func testSuccess() async {
        JSONOperationTestDouble.returnJSON = Self.json

        let model = AlbumsListModelTestDouble()

        var modelDidChange = false
        let modelWillChange = model.objectWillChange.sink { _ in
            modelDidChange = true
        }

        var albumsDidChange = false
        let albumsWillChange = model.$albums.sink { _ in
            if modelDidChange {
                albumsDidChange = true
            }
        }

        do {
            try await model.requestAlbums()

            XCTAssertTrue(albumsDidChange)

            XCTAssertEqual(
                JSONOperationTestDouble.parameterRequest,
                Self.request
            )

            XCTAssertEqual(model.albums, Self.albums)
        } catch {
            XCTFail("testSuccess failed")
        }

        modelWillChange.cancel()
        albumsWillChange.cancel()
    }
}
