//
//  NetworkImageSerialization.swift
//  Albums
//
//  Created by Florian Bruder on 28.12.21.
//

// swiftlint:disable identifier_name

import Foundation

protocol NetworkImageSerializationImageSource {
    associatedtype ImageSource
    associatedtype Image

    static func createImageSource(with: CFData, options: CFDictionary?) -> ImageSource?
    static func createImage(with: ImageSource, at: Int, options: CFDictionary?) -> Image?
}

extension NetworkImageSource: NetworkImageSerializationImageSource {}
