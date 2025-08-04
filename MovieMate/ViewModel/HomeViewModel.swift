//
//  HomeViewModel.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//
import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let repository = MovieRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovies() {
        isLoading = true
        
        Publishers.Zip(
            //repository.fetchTrandingMovies(),
            repository.fetchPopularMovies(),
            repository.fetchUpcomingMovies()
        )
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] popular, upcoming in
            //self?.trendingMovies = trending
            self?.popularMovies = popular
            self?.upcomingMovies = upcoming
        }
        .store(in: &cancellables)
    }
}
