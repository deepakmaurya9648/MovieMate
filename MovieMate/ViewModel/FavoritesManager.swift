//
//  FavoritesManager.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

import Foundation

final class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [Movie] = []

    func add(_ movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }

    func remove(_ movie: Movie) {
        favorites.removeAll { $0.id == movie.id }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
}
