//
//  ListMovieTableViewCell.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit
import Kingfisher

class ListMovieTableViewCell: UITableViewCell {
  @IBOutlet weak var backdropImage: UIImageView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var popularityLabel: UILabel!
  @IBOutlet weak var avgVoteLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setUI(movie: Movie) {
    let baseUrl: String = "https://image.tmdb.org/t/p/original"
    
    titleLabel.text = movie.title
    popularityLabel.text = "\(movie.popularity)"
    // add user never vote this movie
    
    let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
    if avg == 0 {
      avgVoteLabel.text = "\(movie.vote_average)"
    } else {
      let movieAverage = ((movie.vote_count * movie.vote_average) + avg) / (movie.vote_count + 1)
      avgVoteLabel.text = "\(round(movieAverage))"
    }
  
    
    if let backdrop = movie.backdrop_path {
      let urlBackdrop = URL(string: "\(baseUrl)\(backdrop)")
      backdropImage.kf.setImage(with: urlBackdrop)
    }
    
    if let poster = movie.poster_path {
      let urlPoster = URL(string: "\(baseUrl)\(poster)")
      posterImage.kf.setImage(with: urlPoster)
    }
  }
  
}
