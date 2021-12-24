//
//  NetworkJSONHandler.swift
//  Albums
//
//  Created by Florian Bruder on 24.12.21.
//

// swiftlint:disable nesting

import Foundation

struct NetworkJSONHandler {
    struct Error: Swift.Error {
        enum Code {
            case mimeTypeError
            case dataHandlerError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }

    static func json(with: Data, response: URLResponse) throws {
        guard
            let mimeType = response.mimeType?.lowercased(),
            mimeType == "text/javascript"
        else {
            throw Self.Error(.mimeTypeError)
        }
        throw Self.Error(.dataHandlerError)
    }
}
