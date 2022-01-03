//
//  NetworkImageHandler.swift
//  Albums
//
//  Created by Florian Bruder on 29.12.21.
//

// swiftlint:disable nesting

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

extension NetworkImageSerialization: NetworkImageHandlerImageSerialization where ImageSource == NetworkImageSource {}

// MARK: -

struct NetworkImageHandler<
    DataHandler: NetworkImageHandlerDataHandler,
    ImageSerialization: NetworkImageHandlerImageSerialization
> {}

extension NetworkImageHandler {
    struct Error: Swift.Error {
        enum Code {
            case mimeTypeError
            case dataHandlerError
            case imageSerializationError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

extension NetworkImageHandler {
    static func image(with data: Data, response: URLResponse) throws -> ImageSerialization.Image {
        guard
            let mimeType = response.mimeType?.lowercased(),
            mimeType == "image/png"
        else {
            throw Self.Error(.mimeTypeError)
        }

        let data = try { () -> Data in
            do {
                return try DataHandler.data(with: data, response: response)
            } catch {
                throw Self.Error(.dataHandlerError, underlying: error)
            }
        }()

        do {
            return try ImageSerialization.image(with: data)
        } catch {
            throw Self.Error(.imageSerializationError, underlying: error)
        }
    }
}
