//
//  MovieRowView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

struct MovieRowView: View {
    let movies: [Movie]
    @State private var selectedMovie: Movie? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(movies) { movie in
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: movie.posterURL)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: 120, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                    }
                    .onTapGesture {
                        selectedMovie = movie
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black)
        .fullScreenCover(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, popularMovies: movies)
        }
    }
}



//#Preview {
//    MovieRowView(movies: mockMovies)
//}


struct MovieCardView: View {
    let movie: Movie
    var body: some View {
        AsyncImage(url: URL(string: movie.posterURL)){ image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipped()
        } placeholder: {
            ProgressView()
                .frame(height: 400)
        }
            
    }
}
