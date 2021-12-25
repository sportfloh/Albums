//
//  NetworkDataHandler.swift
//  Albums
//
//  Created by Florian Bruder on 23.12.21.
//

// swiftlint:disable nesting

import Foundation

struct NetworkDataHandler {}

extension NetworkDataHandler {
    struct Error: Swift.Error {
        enum Code {
            case statusCodeError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

extension NetworkDataHandler {
    static func data(with data: Data, response: URLResponse) throws -> Data {
        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            200 ... 299 ~= statusCode
        else {
            throw Self.Error(.statusCodeError)
        }
        return data
    }
}
