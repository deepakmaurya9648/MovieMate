//
//  RequestBuilder.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import Foundation

struct RequestBuilder{
    private static let baseURL = "https://api.themoviedb.org/3"
    private static let api_key = "6d58530d6f2607f7d63929b159b82662"
    
    static func requestBuilder(for endpoint: ApiEndpoint) -> URLRequest? {
        guard var component = URLComponents(string: "\(baseURL)/\(endpoint.path)") else {
            return nil
        }
        var queryItems = endpoint.queryItems
        queryItems.append(URLQueryItem(name: "api_key", value: api_key))
        component.queryItems = queryItems
        guard let url = component.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        return request
    }
    
}
