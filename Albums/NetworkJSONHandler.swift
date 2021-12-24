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
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(
            _ code: Self.Code,
            underlying: Swift.Error? = nil
        ) {
            self.code = code
            self.underlying = underlying
        }
    }

    static func json(
        with: Data,
        response: URLResponse
    ) throws {
        throw Self.Error(.mimeTypeError)
    }
}
