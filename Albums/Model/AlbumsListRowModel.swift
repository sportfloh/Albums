//
//  AlbumsListRowModel.swift
//  Albums
//
//  Created by Florian Bruder on 08.01.22.
//

import Foundation

// MARK: -

protocol AlbumsListRowModelsImageOperation {
    associatedtype Image

    static func image(for: URLRequest) async throws -> Image
}

extension NetworkImageOperation: AlbumsListRowModelsImageOperation where
    Session == NetworkSession<Foundation.URLSession>,
    ImageHandler == NetworkImageHandler<
        NetworkDataHandler,
        NetworkImageSerialization<NetworkImageSource>
    > {}

// MARK: -

@MainActor final class AlbumsListRowModel<ImageOperation: AlbumsListRowModelsImageOperation>: ObservableObject {
    @Published private(set) var image: ImageOperation.Image?

    private let album: Album

    init(album: Album) {
        self.album = album
    }
}

extension AlbumsListRowModel {
    var artist: String {
        self.album.artist
    }

    var name: String {
        self.album.name
    }
}

extension AlbumsListRowModel {
    func requestImage() async throws {
        if let url = URL(string: self.album.image) {
            let request = URLRequest(url: url)
            let image = try await ImageOperation.image(for: request)
            self.image = image
        }
    }
}
