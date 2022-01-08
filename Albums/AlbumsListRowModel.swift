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

extension NetworkImageOperation: AlbumsListRowModelsImageOperation where Session == NetworkSession<Foundation.URLSession>, ImageHandler == NetworkImageHandler<NetworkDataHandler, NetworkImageSerialization<NetworkImageSource>> {}

// MARK: -

@MainActor final class AlbumsListRowModel<ImageOperation: AlbumsListRowModelsImageOperation>: ObservableObject {
    @Published private(set) var image: ImageOperation.Image?

    init(album: Album) {}
}

// MARK: - Properties

extension AlbumsListRowModel {
    var artist: String {
        String()
    }

    var name: String {
        String()
    }
}

// MARK: -

extension AlbumsListRowModel {
    func requestImage() async throws {}
}
