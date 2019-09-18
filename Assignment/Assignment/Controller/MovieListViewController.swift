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
  
  var movies: [Movie] = []
  var movie: Movie?
  var page: Int = 1
  var sort: String = "release_date.desc"
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(MovieListViewController.handleRefresh(_:)),
                             for: UIControl.Event.valueChanged)
    refreshControl.tintColor = UIColor.gray

    return refreshControl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovie(page: self.page, sort: self.sort)
    
    let bundle = Bundle(for: ListMovieTableViewCell.self)
    let nib = UINib(nibName: "ListMovieTableViewCell", bundle: bundle)
    tableView.register(nib, forCellReuseIdentifier: "ListMovieTableViewCell")
    
    self.tableView.addSubview(self.refreshControl)
    
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    self.page = 1
    self.getMovie(page: self.page, sort: self.sort)
    refreshControl.endRefreshing()
  }
  
  @IBAction func sortButton(_ sender: Any) {
    let optionMenu = UIAlertController(title: "Sort by relase date", message: "Choose Option", preferredStyle: .actionSheet)
    
    let ascending = UIAlertAction(title: "ASC", style: .default, handler: { _ in
      self.page = 1
      self.sort = "release_date.asc"
      self.getMovie(page: self.page, sort: self.sort)
    })
    let descending = UIAlertAction(title: "DESC", style: .default, handler: { _ in
      self.page = 1
      self.sort = "release_date.desc"
      self.getMovie(page: self.page, sort: self.sort)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    optionMenu.addAction(descending)
    optionMenu.addAction(ascending)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
  
  func getMovie(page: Int, sort: String) {
    APIManager().getMoviesList(page: page, sort: sort) { [weak self] result in
      switch result {
      case .success(let movies):
        if page == 1 {
          self?.movies = movies.results
        } else {
          self?.movies.append(contentsOf: movies.results)
        }
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.page += 1
          print("page \(self?.page)")
        }
      case .failure(_):
        self?.showErrorMessage()
      }
    }
  }
  
  func showErrorMessage() {
    let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMovieDetail" {
      if let viewController = segue.destination as? MovieDetailViewController {
        viewController.movie = movie
      }
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
      getMovie(page: page, sort: sort)
    }
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
