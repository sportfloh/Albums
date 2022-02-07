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
> {
    struct Error: Swift.Error {
        enum Code {
            case sessionError
            case imageHandlerError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

// MARK: -

extension NetworkImageOperation {
    static func image(for request: URLRequest) async throws -> ImageHandler.Image {
        let (data, response) = try await { () -> (Data, URLResponse) in
            do {
                return try await Session.data(for: request)
            } catch {
                throw Self.Error(.sessionError, underlying: error)
            }
        }()

        do {
            return try ImageHandler.image(with: data, response: response)
        } catch {
            throw Self.Error(.imageHandlerError, underlying: error)
        }
    }
}
