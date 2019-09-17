//
//  APIManager.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidJson
    case invalidData
}

class APIManager {
    let apiKey: String = "328c283cd27bd1877d9080ccb1604c91"
    let baseUrl: String = "https://image.tmdb.org/t/p/original"
    
    func getMoviesList(page: Int, sort: String, completion: @escaping(Result<ListMovie, APIError>) -> Void) {
        let urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&primary_release_date.lte=2016-12-31&sort_by=\(sort)&page=\(page)"
        request(urlString: urlString, completion: completion)
    }
    
    func getMovieDetail(id: Int, completion: @escaping(Result<MovieDetail, APIError>) -> Void) {
      let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)"
      request(urlString: urlString, completion: completion)
    }
    
    private func request<T: Codable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("request: \(request)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.invalidData))
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        print("data: \(data)")
                        let values = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        print("error: \(error)")
                        completion(.failure(.invalidJson))
                    }
                }
            }
        }
        task.resume()
    }
}
