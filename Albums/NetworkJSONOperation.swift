//
//  NetworkJSONOperation.swift
//  Albums
//
//  Created by Florian Bruder on 05.01.22.
//

import Foundation

// MARK: -

protocol NetworkJSONOperationSession {
    static func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkSession: NetworkJSONOperationSession where URLSession == Foundation.URLSession {}

// MARK: -

protocol NetworkJSONOperationJSONHandler {
    associatedtype JSON

    static func json(with: Data, response: URLResponse) throws -> JSON
}

// MARK: -

struct NetworkJSONOperation<
    Session: NetworkJSONOperationSession,
    JSONHandler: NetworkJSONOperationJSONHandler
> {
    struct Error: Swift.Error {
        enum Code {
            case sessionError
            case jsonHandlerError
        }

        let code: Self.Code?
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

extension NetworkJSONOperation {
    static func json(for request: URLRequest) async throws -> JSONHandler.JSON {
        let (data, response) = try await { () -> (Data, URLResponse) in
            do {
                return try await Session.data(for: request)
            } catch {
                throw Self.Error(.sessionError, underlying: error)
            }
        }()

        do {
            return try JSONHandler.json(with: data, response: response)
        } catch {
            throw Self.Error(.jsonHandlerError, underlying: error)
        }
    }
}
