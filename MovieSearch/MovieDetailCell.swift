//
//  MovieDetailCell.swift
//  MovieSearch
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    var moviePoster: UIImageView!
    var movieTitle: UILabel!
    var releaseDate: UILabel!
    var movieOverview: UILabel!
    var width = 0
    
    init(width: Int, data: Movies?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "")
        selectionStyle = UITableViewCellSelectionStyle.none
        self.width = width
        
        configureCell()
        let overViewHeight = data?.overview?.heightWithConstrainedWidth(width: CGFloat(3*width/4 - 32), font: UIFont.systemFont(ofSize: 12.0)) ?? 75
        let movieOverviewHeight = max(overViewHeight, 75)
        movieOverview = UILabel(frame: CGRect(x: width/4 + 16, y: 53, width: 3*width/4 - 24, height: Int(ceil(movieOverviewHeight))))
        movieOverview.font = UIFont.systemFont(ofSize: 12.0)
        
        self.movieTitle.text = data?.title
        self.releaseDate.text = formatDate(release_date: data?.release_date)
        self.movieOverview.text = data?.overview
        self.movieOverview.numberOfLines = 0
        if let image = data?.poster_path, let imageURL = URL(string: "https://image.tmdb.org/t/p/w92/" + image) {
            self.moviePoster.loadImage(from: imageURL)
            self.moviePoster.contentMode = .scaleToFill
        } else {
            self.moviePoster.image = UIImage(named: "Placeholder")
            self.moviePoster.contentMode = .scaleAspectFit
        }
        addSubview(moviePoster)
        addSubview(movieTitle)
        addSubview(releaseDate)
        addSubview(movieOverview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        moviePoster = UIImageView(frame: CGRect(x: 8, y: 8, width: width/4, height: 120))
        let textWidth = 3*width/4 - 24
        movieTitle = UILabel(frame: CGRect(x: width/4 + 16, y: 8, width: Int(textWidth), height: 25))
        movieTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
        releaseDate = UILabel(frame: CGRect(x: width/4 + 16, y: 33, width: Int(textWidth), height: 20))
        releaseDate.font = UIFont.systemFont(ofSize: 12.0)
        releaseDate.textColor = .gray
    }
    
    func formatDate(release_date: String?) -> String {
        let getDate = DateFormatter()
        getDate.dateFormat = "yyyy-MM-dd"
        
        let convertDate = DateFormatter()
        convertDate.dateFormat = "MMM dd, yyyy"
        
        if let date = getDate.date(from: release_date ?? ""){
            return convertDate.string(from: date)
        }
        else {
            return release_date ?? ""
        }
        
    }
}

extension UIImageView {
    func loadImage(from url: URL, session: URLSession = URLSession.shared) {
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            }.resume()
    }
}

