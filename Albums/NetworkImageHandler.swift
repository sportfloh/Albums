//
//  NetworkImageHandler.swift
//  Albums
//
//  Created by Florian Bruder on 29.12.21.
//

import Foundation

// MARK: -

protocol NetworkImageHandlerDataHandler {
    static func data(
        with: Data,
        response: URLResponse
    ) throws -> Data
}

extension NetworkDataHandler: NetworkImageHandlerDataHandler {}

// MARK: -

protocol NetworkImageHandlerImageSerialization {
    associatedtype Image

    static func image(with: Data) throws -> Image
}

extension NetworkImageSerialization: NetworkImageHandlerImageSerialization {}

// MARK: -

struct NetworkImageHandler<
    DataHandler: NetworkImageHandlerDataHandler,
    ImageSerialization: NetworkImageHandlerImageSerialization
> {}

extension NetworkImageHandler {
    static func image(with data: Data, response: URLResponse) throws {}
}
