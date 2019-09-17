//
//  ListMovieTableViewCell.swift
//  Assignment
//
//  Created by Kanchana Phakdeedorn on 16/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit

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
        avgVoteLabel.text = "\(movie.vote_average)"
        
        guard let backdrop = movie.backdrop_path else {
            return
        }
        
        let urlBackdrop = URL(string: "\(baseUrl)\(backdrop)")
        let dataBackdrop = try? Data(contentsOf: urlBackdrop!)
        backdropImage.image = UIImage(data: dataBackdrop!)
        
        guard let poster = movie.poster_path else {
            return
        }
        
        let urlPoster = URL(string: "\(baseUrl)\(poster)")
        let dataPoster = try? Data(contentsOf: urlPoster!)
        posterImage.image = UIImage(data: dataPoster!)
    }
    
}
