//
//  MovieListController.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()
    }
    
    func getMovie() {
        let sort: String = "release_date.desc"
        let page: Int = 1
        APIManager().getMoviesList(page: page, sort: sort) { [weak self] result in
            switch result {
            case .success(let movies):
                 self?.movies = movies.results
            case .failure(_):
                let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}
