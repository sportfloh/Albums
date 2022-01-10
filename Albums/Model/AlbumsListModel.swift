//
//  AlbumsListModel.swift
//  Albums
//
//  Created by Florian Bruder on 06.01.22.
//

// swiftlint:disable line_length identifier_name

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

private func Albums(_ json: Any) -> [Album] {
    var albums = [Album]()
    if let array = ((json as? [String: Any])?["feed"] as? [String: Any])?["entry"] as? [[String: Any]] {
        for dictionary in array {
            if let artist = ((dictionary["im:artist"] as? [String: Any])?["label"] as? String),
               let name = ((dictionary["im:name"] as? [String: Any])?["label"] as? String),
               let image = ((dictionary["im:image"] as? [[String: Any]])?[2]["label"] as? String),
               let id = (((dictionary["id"] as? [String: Any])?["attributes"] as? [String: Any])?["im:id"] as? String) {
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

@MainActor final class AlbumsListModel<JSONOperation: AlbumsListModelJSONOperation>: ObservableObject {
    @Published private(set) var albums = [Album]()
}

extension AlbumsListModel {
    func requestAlbums() async throws {
        if let url = URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=100/json") {
            let request = URLRequest(url: url)
            let json = try await JSONOperation.json(for: request)
            albums = Albums(json)
        }
    }
}
