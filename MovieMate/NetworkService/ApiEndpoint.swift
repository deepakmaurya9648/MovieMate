//
//  ApiEndpoint.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//
import Foundation
import Combine

enum ApiEndpoint{
    case trending
    case popular
    case upcoming
    case search(query: String)
    case videos(movieID: Int)
    
    var path: String {
        switch self {
        case .trending:
            return "/trending/all/week"
        case .popular:
            return "movie/popular"
        case .upcoming:
            return "movie/upcoming"
        case .search(query: let query):
            return "search/movie"
        case .videos(let movieID): return "movie/\(movieID)/videos"
        }
    }
    
    var method: HTTPMethod{
        return .GET
    }
    
    var queryItems: [URLQueryItem] {
            switch self {
            case .search(let query):
                return [URLQueryItem(name: "query", value: query)]
            default:
                return []
            }
        }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
