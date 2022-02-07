//
//  AlbumsListRowView.swift
//  Albums
//
//  Created by Florian Bruder on 08.01.22.
//

import SwiftUI

// MARK: -

@MainActor protocol AlbumsListRowViewModel: ObservableObject {
    var artist: String { get }
    var name: String { get }
    var image: CGImage? { get }

    init(album: Album)

    func requestImage() async throws
}

extension AlbumsListRowModel: AlbumsListRowViewModel where
    ImageOperation == NetworkImageOperation<
        NetworkSession<URLSession>,
        NetworkImageHandler<
            NetworkDataHandler,
            NetworkImageSerialization<NetworkImageSource>
        >
    > {}

// MARK: -

struct AlbumsListRowView<ListRowViewModel: AlbumsListRowViewModel>: View {
    @ObservedObject private var model: ListRowViewModel

    var body: some View {
        HStack {
            if let cgImage = self.model.image {
                Image(decorative: cgImage, scale: 1.0, orientation: .up)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128, alignment: .topLeading)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(self.model.artist)
                    .foregroundColor(.primary)
                    .font(.headline)

                Text(self.model.name)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .task {
            do {
                try await self.model.requestImage()
            } catch {
                print(error)
            }
        }
    }

    init(model: ListRowViewModel) {
        self.model = model
    }
}

// MARK: -

struct AlbumsListRowView_Previews: PreviewProvider {
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

    static var albums: [Album] {
        [
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

    static var previews: some View {
        List(
            self.albums
        ) { album in
            AlbumsListRowView<ListRowModel>(
                model: ListRowModel(album: album)
            )
        }
        .listStyle(.plain)
    }
}
