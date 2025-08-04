//
//  HomeView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedMovie: Movie? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if viewModel.isLoading {
                        ProgressView("Loading Movies...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // FEATURED MOVIE
                        if let featured = viewModel.popularMovies.shuffled().first {
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: URL(string: featured.posterURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 400)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                        .frame(height: 400)
                                }
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 400)
                                
                                HStack(alignment: .center, spacing: 16) {
                                    CustomButton(title: "Play",icon: Image(systemName: "play.fill"),backgroundColor: Color.gray,cornerRadius: 30,height: 10) {
                                        selectedMovie = featured
                                    }.frame(width: 100)
                                    CustomButton(title: "Details",backgroundColor: Color.clear,borderColor: Color.white,cornerRadius: 30,height: 10) {
                                        selectedMovie = featured
                                    }.frame(width: 100)
                                }
                                .padding(.top, 40)
                            }
                        }
                        
                        // MOVIE SECTIONS
                        LazyVStack(alignment: .leading, spacing: 20) {
                            SectionView(title: "Tranding", movies: viewModel.popularMovies)
                            SectionView(title: "Upcoming", movies: viewModel.upcomingMovies)
                        }.padding(.top,20)
                            .padding(.bottom,80)
                    }
                }
            }
            .background(Color.black)
            .ignoresSafeArea(edges: .top)
            .fullScreenCover(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie, popularMovies: viewModel.upcomingMovies)
                    }
        }
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}


struct SectionView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal)
            
            MovieRowView(movies: movies)
        }
    }
}




#Preview {
    HomeView()
}
