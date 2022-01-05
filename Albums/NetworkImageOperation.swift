//
//  NetworkImageOperation.swift
//  Albums
//
//  Created by Florian Bruder on 05.01.22.
//

import Foundation

// MARK: -

protocol NetworkImageOperationSession {
    static func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkSession: NetworkImageOperationSession where URLSession == Foundation.URLSession {}

// MARK: -

protocol NetworkImageOperationImageHandler {
    associatedtype Image

    static func image(with: Data, response: URLResponse) throws -> Image
}

extension NetworkImageHandler: NetworkImageOperationImageHandler where
    DataHandler == NetworkDataHandler,
    ImageSerialization == NetworkImageSerialization<NetworkImageSource> {}

// MARK: -

struct NetworkImageOperation<
    Session: NetworkImageOperationSession,
    ImageHandler: NetworkImageOperationImageHandler
> {}

extension NetworkImageOperation {
    static func image(for request: URLRequest) async throws {}
}
