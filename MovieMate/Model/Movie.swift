//
//  Movie.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//
import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
    var posterURL: String {
        "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

//let mockMovies: [Movie] = [
//    Movie(id: 1, title: "Inception", posterPath: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg"),
//    Movie(id: 2, title: "Interstellar", posterPath: "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg"),
//    Movie(id: 3, title: "Tenet", posterPath: "https://image.tmdb.org/t/p/w500/k68nPLbIST6NP96JmTxmZijEvCA.jpg")
//]
