//
//  AlbumsListModel.swift
//  Albums
//
//  Created by Florian Bruder on 06.01.22.
//

// swiftlint:disable line_length

import Foundation

// MARK: -

protocol AlbumsListModelJSONOperation {
    associatedtype JSON

    static func json(for: URLRequest) async throws -> JSON
}

extension NetworkJSONOperation: AlbumsListModelJSONOperation where Session == NetworkSession<Foundation.URLSession>, JSONHandler == NetworkJSONHandler<NetworkDataHandler, Foundation.JSONSerialization> {}

// MARK: -

struct Album {
    let id: String
    let artist: String
    let name: String
    let image: String
}

extension Album: Hashable {}
extension Album: Identifiable {}

// MARK: -

@MainActor final class AlbumsListModel<JSONOperation: AlbumsListModelJSONOperation>: ObservableObject {
    @Published private(set) var albums = [Album]()
}

extension AlbumsListModel {
    func requestAlbums() async throws {
        if let url = URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=100/json") {
            let request = URLRequest(url: url)
            try await JSONOperation.json(for: request)
        }
    }
}
