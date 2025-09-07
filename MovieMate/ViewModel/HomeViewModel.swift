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
    private let persistence = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadCachedMovies()
    }
    
    private func loadCachedMovies() {
        popularMovies = persistence.fetchMovies(for: "popular")
        upcomingMovies = persistence.fetchMovies(for: "upcoming")
    }
    
    func fetchMovies() {
        isLoading = true
        
        Publishers.Zip(
            repository.fetchPopularMovies(),
            repository.fetchUpcomingMovies()
        )
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] popular, upcoming in
            guard let self = self else { return }
            
            self.popularMovies = popular
            self.upcomingMovies = upcoming
            
            // Cache the fetched movies
            self.persistence.saveMovies(popular, for: "popular")
            self.persistence.saveMovies(upcoming, for: "upcoming")
        }
        .store(in: &cancellables)
    }
}
