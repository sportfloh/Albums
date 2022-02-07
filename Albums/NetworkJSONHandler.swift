//
//  NetworkJSONHandler.swift
//  Albums
//
//  Created by Florian Bruder on 24.12.21.
//

import Foundation

// MARK: -

protocol NetworkJSONHandlerDataHandler {
    static func data(with: Data, response: URLResponse) throws -> Data
}

extension NetworkDataHandler: NetworkJSONHandlerDataHandler {}

// MARK: -

protocol NetworkJSONHandlerJSONSerialization {
    associatedtype JSON

    static func jsonObject(
        with: Data,
        options: JSONSerialization.ReadingOptions
    ) throws -> JSON
}

extension JSONSerialization: NetworkJSONHandlerJSONSerialization {}

// MARK: -

struct NetworkJSONHandler<
    DataHandler: NetworkJSONHandlerDataHandler,
    JSONSerialization: NetworkJSONHandlerJSONSerialization
> {}

extension NetworkJSONHandler {
    struct Error: Swift.Error {
        enum Code {
            case mimeTypeError
            case dataHandlerError
            case jsonSerializationError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

extension NetworkJSONHandler {
    static func json(with data: Data, response: URLResponse) throws -> JSONSerialization.JSON {
        guard
            let mimeType = response.mimeType?.lowercased(),
            mimeType == "text/javascript"
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
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw Self.Error(.jsonSerializationError, underlying: error)
        }
    }
}
