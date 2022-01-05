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
