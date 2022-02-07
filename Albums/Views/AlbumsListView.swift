//
//  AlbumsListView.swift
//  Albums
//
//  Created by Florian Bruder on 10.01.22.
//

import SwiftUI

// MARK: -

@MainActor protocol AlbumsListViewModel: ObservableObject {
    var albums: [Album] { get }

    func requestAlbums() async throws
}

extension AlbumsListModel: AlbumsListViewModel where
    JSONOperation == NetworkJSONOperation<
        NetworkSession<Foundation.URLSession>, NetworkJSONHandler<
            NetworkDataHandler,
            Foundation.JSONSerialization
        >
    > {}

// MARK: -

struct AlbumsListView<ListViewModel: AlbumsListViewModel, ListRowViewModel: AlbumsListRowViewModel>: View {
    @ObservedObject private var model: ListViewModel

    var body: some View {
        List(
            self.model.albums
        ) { album in
            AlbumsListRowView<ListRowViewModel>(
                model: ListRowViewModel(album: album)
            )
        }
        .listStyle(.plain)
        .task {
            do {
                try await self.model.requestAlbums()
            } catch {
                print(error)
            }
        }
    }

    init(model: ListViewModel) {
        self.model = model
    }
}

// MARK: -

struct AlbumsListView_Previews: PreviewProvider {
    private final class ListModel: AlbumsListViewModel {
        @Published private(set) var albums = [Album]()

        func requestAlbums() async throws {
            self.albums = [
                Album(
                    id: "Rubber Soul",
                    artist: "Beatles",
                    name: "Rubber Soul",
                    image: "http://localhost/rubber-soul.jpeg"
                ),
                Album(
                    id: "Pet Sounds",
                    artist: "Beach Boys",
                    name: "Pet Sounds",
                    image: "http://localhost/pet-sounds.jpeg"
                )
            ]
        }
    }

    private final class ListRowModel: AlbumsListRowViewModel {
        let artist: String
        let name: String

        @Published private(set) var image: CGImage?

        init(album: Album) {
            self.artist = album.artist
            self.name = album.name
        }

        func requestImage() async throws {
            if let context = CGContext(
                data: nil,
                width: 256,
                height: 256,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) {
                context.setFillColor(
                    red: 0.5,
                    green: 0.5,
                    blue: 0.5,
                    alpha: 1
                )
                context.fill(
                    CGRect(
                        x: 0,
                        y: 0,
                        width: 256,
                        height: 256
                    )
                )
                self.image = context.makeImage()
            }
        }
    }

    static var previews: some View {
        AlbumsListView<ListModel, ListRowModel>(
            model: ListModel()
        )
    }
}
