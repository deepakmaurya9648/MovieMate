//
//  NetworkClient.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import Foundation
import Combine

final class NetworkClient {
    static let shared = NetworkClient()
    
    private init() {}
    
    func execute<T: Decodable>(_ endPoint: ApiEndpoint,decodeTo type: T.Type)-> AnyPublisher<T,Error>{
        guard let request = RequestBuilder.requestBuilder(for: endPoint)else{
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request).tryMap {
            output in
            guard let response = output.response as? HTTPURLResponse,200..<300 ~= response.statusCode else {
                throw URLError(.badServerResponse)
            }
            return output.data
        }.decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
