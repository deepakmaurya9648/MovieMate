//
//  MovieDetailViewModel.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

import Combine
import SwiftUI

final class MovieDetailViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let repository = MovieRepository()
    private var cancellables = Set<AnyCancellable>()

    func fetchVideos(for movieID: Int) {
        isLoading = true
        repository.fetchVideos(for: movieID)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] videos in
                self?.videos = videos.filter { $0.site == "YouTube" && $0.type == "Trailer" }
            }
            .store(in: &cancellables)
    }
}
