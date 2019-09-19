//
//  MovieDetailViewController.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 17/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class MovieDetailViewController: UIViewController {
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var starVotingView: CosmosView!
  
  // change to store only movie id
  var id: Int?
//  var movie: Movie?
  var movieDetail: MovieDetail?
  // no need
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // remove force unwrapped
    if let id = id {
      getMovieDetail(id: id)
    }
    
    // set as function
    checkVoting()
    setStarforVoting()
  }
  
  func checkVoting() {
    // use id to get vote
    if let id = id {
      let value = UserDefaults.standard.double(forKey: "\(id)")
      let vote = value / 2.0
      starVotingView.rating = vote
    }
  }
  
  func setStarforVoting() {
    starVotingView.settings.minTouchRating = 0
    starVotingView.settings.fillMode = .half
    starVotingView.settings.totalStars = 5
    
    starVotingView.didFinishTouchingCosmos = { rating in
      let vote = rating * 2
      self.setVoting(vote: vote)
    }
  }
  
  func setVoting(vote: Double) {
    // remove force unwrapped
    if let id = id {
      UserDefaults.standard.set(vote, forKey: "\(id)")
      print("id: \(id)")
    }
  }
  
  func getMovieDetail(id: Int) {
      APIManager().getMovieDetail(id: id) { [weak self] result in
        switch result {
        case .success(let movieDetail):
          self?.movieDetail = movieDetail
          DispatchQueue.main.async {
            self?.updateUI()
          }
        case .failure(_):
          let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
          self?.present(alert, animated: true)
        }
      }
  }
  
  // updateUI
  func updateUI() {
    let baseUrl: String = "https://image.tmdb.org/t/p/original"
    
    titleLabel.text = movieDetail?.title
    overviewLabel.text = movieDetail?.overview
    languageLabel.text = movieDetail?.original_language
    
    if let collection = movieDetail?.genres {
      if !collection.isEmpty {
        // show all genres
        var genres: String = ""
        for index in collection {
          genres.append(contentsOf: "\(index.name) ")
        }
        genreLabel.text = genres
      }
    } else {
      genreLabel.text = "-"
    }
    
    if let poster = movieDetail?.poster_path {
      let posterUrl = URL(string: "\(baseUrl)\(poster)")
      posterImage.kf.setImage(with: posterUrl)
    }
    
  }
}
