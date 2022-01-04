//
//  NetworkSession.swift
//  Albums
//
//  Created by Florian Bruder on 04.01.22.
//

import Foundation

// MARK: -

protocol NetworkSessionURLSession {
    associatedtype URLSession: NetworkSessionURLSession

    static var shared: URLSession { get }

    func data(
        for: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSessionURLSession {}

// MARK: -

struct NetworkSession<URLSession: NetworkSessionURLSession> {}

extension NetworkSession {
    static func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: request, delegate: nil)
    }
}
