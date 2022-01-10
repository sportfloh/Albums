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

extension AlbumsListModel: AlbumsListViewModel where JSONOperation == NetworkJSONOperation<NetworkSession<Foundation.URLSession>, NetworkJSONHandler<NetworkDataHandler, Foundation.JSONSerialization>> {}

// MARK: -

struct AlbumsListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: -

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListView()
    }
}
