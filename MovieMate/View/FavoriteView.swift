//
//  FavoriteView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedMovie: Movie? = nil

    private let gridLayout = [
        GridItem(.fixed(120), spacing: 16),
        GridItem(.fixed(120), spacing: 16)
    ]

    var body: some View {
        VStack {
            if favoritesManager.favorites.isEmpty {
                Text("No Favorites Yet")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(favoritesManager.favorites) { movie in
                            AsyncImage(url: URL(string: movie.posterURL)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                Color.gray
                                    .frame(width: 120, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .onTapGesture {
                                selectedMovie = movie
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.black)
        .fullScreenCover(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, popularMovies: favoritesManager.favorites)
        }
    }
}
