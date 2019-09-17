//
//  ListMovie.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import Foundation

struct ListMovie: Codable {
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Movie]
}

struct Movie: Codable {
    var id: Int
    var title: String
    var popularity: Float
    var vote_count: Int
    var vote_average: Float
    var backdrop_path: String?
    var poster_path: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case popularity
//        case voteCount = "vote_count"
//        case voteAverage = "vote_average"
//        case backdropPath = "backdrop_path"
//        case posterPath = "poster_path"
//    }
}
