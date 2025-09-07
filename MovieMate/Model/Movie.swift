//
//  Movie.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//
import Foundation
import CoreData

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

extension Movie{
    func toEntity(context: NSManagedObjectContext) -> CachedMovie{
        let entity = CachedMovie(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.posterPath = posterPath
        entity.overview = overview
        entity.releaseDate = releaseDate
        entity.voteAverage = voteAverage ?? 0.0
        return entity
    }
}
