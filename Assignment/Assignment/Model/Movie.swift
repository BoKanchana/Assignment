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
}

struct MovieDetail: Codable {
  var id: Int
  var title: String
  var overview: String
  var original_language: String
  var vote_average: Float
  var genres: [genre]
  var poster_path: String
}

struct genre: Codable {
  var id: Int
  var name: String
}
