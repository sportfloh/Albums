//
//  AlbumsListModel.swift
//  Albums
//
//  Created by Florian Bruder on 06.01.22.
//

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
