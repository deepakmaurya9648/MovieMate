//
//  Video.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

struct VideoResponse: Decodable {
    let results: [Video]
}

struct Video: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
