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
  @IBOutlet weak var overviewLabel: UITextView!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  
  var movie: Movie?
  var movieDetail: MovieDetail?
  var vote: Double = 0.0
  
  lazy var cosmosView: CosmosView = {
    var view = CosmosView()
    
    view.rating = self.vote
    view.settings.totalStars = 5
    view.settings.starSize = 30
    view.settings.fillMode = .half
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkVoting()
    
    view.addSubview(cosmosView)
    cosmosView.centerInSuperview()
    
    cosmosView.didFinishTouchingCosmos = { rating in
      let vote = rating * 2
      self.setVoting(vote: vote)
    }
    getMovieDetail(id: movie!.id)
  }
  
  func checkVoting() {
    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
      if Int(key) == movie?.id {
        let values = value as! Double / 2
        self.vote = values
      }
    }
  }
  
  func setVoting(vote: Double) {
    UserDefaults.standard.set(vote, forKey: "\(movie!.id)")
  }
  
  func getMovieDetail(id: Int) {
      APIManager().getMovieDetail(id: id) { [weak self] result in
        switch result {
        case .success(let movieDetail):
          self?.movieDetail = movieDetail
          DispatchQueue.main.async {
            self?.setUI()
          }
        case .failure(_):
          let alert = UIAlertController(title: "Error", message: "No data found, please try again", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
          self?.present(alert, animated: true)
        }
      }
  }
  
  func setUI() {
    let baseUrl: String = "https://image.tmdb.org/t/p/original"
    
    titleLabel.text = movieDetail?.title
    overviewLabel.text = movieDetail?.overview
    languageLabel.text = movieDetail?.original_language
    
    if let collection = movieDetail?.genres {
      if !collection.isEmpty {
        genreLabel.text = collection[0].name
      }
    }
    
    if let poster = movieDetail?.poster_path {
      let posterUrl = URL(string: "\(baseUrl)\(poster)")
      posterImage.kf.setImage(with: posterUrl)
    }
    
  }
}
