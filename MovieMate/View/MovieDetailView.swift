//
//  MovieDetailView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

import SwiftUI
import AVKit

struct MovieDetailView: View {
    @State var movie: Movie              // Change to @State
    let popularMovies: [Movie]
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    private var recommendedMovies: [Movie] {
        popularMovies.filter { $0.id != movie.id }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Trailer + Back Button
            ZStack(alignment: .topLeading) {
                if viewModel.isLoading {
                    AsyncImage(url: URL(string: movie.posterURL)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .frame(height: 300)
                        .background(Color.black)
                } else if let trailer = viewModel.videos.first {
                    YouTubePlayerView(videoKey: trailer.key)
                        .frame(height: 300)
                        .padding(.top, 50)
                } else {
                    Color.gray.frame(height: 300)
                    Text("No Trailer Available")
                        .foregroundColor(.gray)
                }
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                            .padding(.leading, 16)
                            .padding(.top,0)
                    }
                    Spacer()
                    Button(action: {
                        if favoritesManager.isFavorite(movie) {
                            favoritesManager.remove(movie)
                        } else {
                            favoritesManager.add(movie)
                            NotificationManager.shared.scheduleNotification(
                                        title: "Movie Mate",
                                        body: "\(movie.title ?? "") has added to your wishlist",
                                        after: 1 // small delay for UX
                                    )
                        }
                    }) {
                        Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .padding(10)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
            }
            
            // Details + Recommended
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title ?? "")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Release Date: \(movie.releaseDate ?? "N/A")")
                        .foregroundColor(.gray)
                    
                    Text("Rating: \(String(format: "%.1f", movie.voteAverage ?? 0.0))")
                        .foregroundColor(.yellow)
                    
                    Text(movie.overview ?? "No description available.")
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    if !recommendedMovies.isEmpty {
                        Text("Recommended")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(recommendedMovies) { recommended in
                                    AsyncImage(url: URL(string: recommended.posterURL)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 120, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        movie = recommended                // Replace current movie
                                        viewModel.fetchVideos(for: recommended.id) // Fetch new trailer
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
                .padding()
            }
            .background(Color.black)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.fetchVideos(for: movie.id)
        }
    }
}



//#Preview {
//    MovieDetailView()
//}
