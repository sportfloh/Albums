//
//  NetworkImageSerialization.swift
//  Albums
//
//  Created by Florian Bruder on 28.12.21.
//

// swiftlint:disable identifier_name nesting

import Foundation

protocol NetworkImageSerializationImageSource {
    associatedtype ImageSource
    associatedtype Image

    static func createImageSource(with: CFData, options: CFDictionary?) -> ImageSource?
    static func createImage(with: ImageSource, at: Int, options: CFDictionary?) -> Image?
}

extension NetworkImageSource: NetworkImageSerializationImageSource {}

struct NetworkImageSerialization<ImageSource: NetworkImageSerializationImageSource> {}

extension NetworkImageSerialization {
    struct Error: Swift.Error {
        enum Code {
            case imageSourceError
        }

        let code: Self.Code
        let underlying: Swift.Error?

        init(_ code: Self.Code, underlying: Swift.Error? = nil) {
            self.code = code
            self.underlying = underlying
        }
    }
}

extension NetworkImageSerialization {
    static func image(with data: Data) throws -> ImageSource.Image {
        let imageSource = ImageSource.createImageSource(
            with: data as CFData,
            options: nil)
        throw Self.Error(.imageSourceError)
    }
}
