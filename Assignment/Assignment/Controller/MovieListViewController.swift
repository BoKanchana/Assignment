//
//  MovieListController.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListViewControllerProtocol {
  func presentMoviesList()
}

class MovieListViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  
  var movies: [Movie] = []
  var page: Int = 1
  var sort: String = "release_date.desc"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: ListMovieTableViewCell.self)
    let nib = UINib(nibName: "ListMovieTableViewCell", bundle: bundle)
    tableView.register(nib, forCellReuseIdentifier: "ListMovieTableViewCell")
    getMovie(sort: self.sort)
  }
  
  func getMovie(sort: String) {
    APIManager().getMoviesList(page: page, sort: sort) { [weak self] result in
      switch result {
      case .success(let movies):
        self?.movies = movies.results
        self?.tableView.reloadData()
        self?.page += 1
      case .failure(_):
        let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self?.present(alert, animated: true)
      }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if offsetY > contentHeight - scrollView.frame.height {
      getMovie(sort: sort)
    }
  }
}

extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieTableViewCell", for: indexPath) as? ListMovieTableViewCell else {
      return UITableViewCell()
    }
    let movie: Movie = movies[indexPath.row]
    cell.setUI(movie: movie)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == movies.count - 1 {
      getMovie(sort: sort)
    }
  }
}
