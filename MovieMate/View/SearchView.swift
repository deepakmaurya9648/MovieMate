//
//  SearchView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedMovie: Movie? = nil
    // Define grid layout
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for a movie, show, etc.", text: $viewModel.query)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.darkGray))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top, 10)

            // Results or Top Searches
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Top Searches")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    ScrollView {
                        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 20) {
                            ForEach(viewModel.results) { movie in
                                VStack(spacing: 8) {
                                    AsyncImage(url: URL(string: movie.posterURL)) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 140, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 120, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }

                                    Text(movie.title ?? "")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .frame(width: 120)
                                }
                                .onTapGesture {
                                    selectedMovie = movie
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }

                    .padding(.horizontal)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .fullScreenCover(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, popularMovies: viewModel.results)
        }
    }
}


#Preview {
    SearchView()
}
