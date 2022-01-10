//
//  AlbumsApp.swift
//  Albums
//
//  Created by Florian Bruder on 23.12.21.
//

// swiftlint:disable line_length

import SwiftUI

// MARK: -

@main
struct AlbumsApp: App {
    private typealias JSONHandler = NetworkJSONHandler<NetworkDataHandler, JSONSerialization>
    private typealias ImageHandler = NetworkImageHandler<NetworkDataHandler, NetworkImageSerialization<NetworkImageSource>>

    private typealias JSONOperation = NetworkJSONOperation<NetworkSession<URLSession>, JSONHandler>
    private typealias ImageOperation = NetworkImageOperation<NetworkSession<URLSession>, ImageHandler>

    private typealias ListModel = AlbumsListModel<JSONOperation>
    private typealias ListRowModel = AlbumsListRowModel<ImageOperation>

    private typealias ListView = AlbumsListView<ListModel, ListRowModel>

    @StateObject private var model = ListModel()

    var body: some Scene {
        WindowGroup {
            ListView(
                model: self.model
            )
        }
    }
}
