//
//  MovieRepository.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import Foundation
import Combine

final class MovieRepository{
    func fetchTrandingMovies() -> AnyPublisher<[Movie],Error>{
        NetworkClient.shared.execute(.trending,decodeTo: MovieResponse.self)
            .map{$0.results}
            .eraseToAnyPublisher()
    }
    
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
            NetworkClient.shared.execute(.popular, decodeTo: MovieResponse.self)
                .map { $0.results }
                .eraseToAnyPublisher()
        }
        
        func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error> {
            NetworkClient.shared.execute(.upcoming, decodeTo: MovieResponse.self)
                .map { $0.results }
                .eraseToAnyPublisher()
        }
        
        func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
            NetworkClient.shared.execute(.search(query: query), decodeTo: MovieResponse.self)
                .map { $0.results }
                .eraseToAnyPublisher()
        }
    
    func fetchVideos(for movieID: Int) -> AnyPublisher<[Video], Error> {
            NetworkClient.shared.execute(.videos(movieID: movieID), decodeTo: VideoResponse.self)
                .map { $0.results }
                .eraseToAnyPublisher()
        }
}
