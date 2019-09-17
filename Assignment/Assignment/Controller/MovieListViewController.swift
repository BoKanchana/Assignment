//
//  MovieListController.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  @IBAction func sortButton(_ sender: Any) {
    let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: "ASD", style: .default)
    let saveAction = UIAlertAction(title: "DESC", style: .default)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    optionMenu.addAction(deleteAction)
    optionMenu.addAction(saveAction)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
  
  var movies: [Movie] = []
  var movie: Movie?
  var page: Int = 1
  var sort: String = "release_date.desc"

  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovie(page: self.page, sort: self.sort)
    
    let bundle = Bundle(for: ListMovieTableViewCell.self)
    let nib = UINib(nibName: "ListMovieTableViewCell", bundle: bundle)
    tableView.register(nib, forCellReuseIdentifier: "ListMovieTableViewCell")
    
  }
  
  func getMovie(page: Int, sort: String) {
    APIManager().getMoviesList(page: page, sort: sort) { [weak self] result in
      switch result {
      case .success(let movies):
        self?.movies = movies.results
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.page += 1
        }
      case .failure(_):
        let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self?.present(alert, animated: true)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMovieDetail" {
      if let viewController = segue.destination as? MovieDetailViewController {
        viewController.movie = movie
      }
    }
  }
  
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let offsetY = scrollView.contentOffset.y
//    let contentHeight = scrollView.contentSize.height
//    if offsetY > contentHeight - scrollView.frame.height {
//      getMovie(page: page, sort: sort)
//    }
//  }
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
}

extension MovieListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.movie = movies[indexPath.row]
    self.performSegue(withIdentifier: "showMovieDetail", sender: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
  }
}
