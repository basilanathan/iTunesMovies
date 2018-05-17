//
//  MovieDetailViewController.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var posterThumbnailView: UIImageView!

    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMovieInformation()
        updateFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    func updateFavoriteButton() {
        guard let favorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [[String : Any]] else {
            return
        }
        guard let movieId = movie?.id else {
            return
        }
        if favorites.contains(where: { (movieInfo) -> Bool in
            return movieId == movieInfo["trackId"] as? Int
        }) {
            favoriteButton.isEnabled = false
            favoriteButton.backgroundColor = .purple
        }
        
    }
    
    func populateMovieInformation() {
        guard let theMovie = movie else {
            return
        }
        titleLabel.text = theMovie.title
        genreLabel.text = "Genre: \(theMovie.genre ?? "Unknown")"
        descriptionLabel.text = theMovie.longInfo
        self.posterImageView.image = #imageLiteral(resourceName: "PosterPlaceholder")
        MovieUtility.shared.getPosterImageFor(movie: theMovie) {[weak self] (image) in
            self?.posterImageView.image = image
        }
        posterThumbnailView.image = #imageLiteral(resourceName: "PosterPlaceholder")
        MovieUtility.shared.getLargePosterImageFor(movie: theMovie) { (image) in
            self.posterThumbnailView.image = image
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favoriteButton.layer.cornerRadius = 10
        favoriteButton.layer.masksToBounds = true
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        guard let movieInfo = movie?.movieInfo else {
            return
        }
        sender.backgroundColor = .purple
        sender.isEnabled = false
        guard var favorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [[String : Any]] else {
            UserDefaults.standard.set([movieInfo], forKey: "favoriteMovies")
            
            return
        }
        favorites.append(movieInfo)
        UserDefaults.standard.set(favorites, forKey: "favoriteMovies")
    }
    
   
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
