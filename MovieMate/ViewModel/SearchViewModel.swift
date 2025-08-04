//
//  SearchViewModel.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Movie] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe query changes and debounce
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.performSearch(text)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ text: String) {
        guard !text.isEmpty else {
            results = []
            return
        }

        NetworkClient.shared
            .execute(.search(query: text), decodeTo: MovieResponse.self)
            .map { $0.results }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
    }
}

