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
