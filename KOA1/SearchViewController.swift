//
//  SearchViewController.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
    var isSearching = false
    var searchCount = 0
    var completedCount = 0
    var isFavoritesView = false
    
    @IBOutlet weak var emptyDataTitle: UILabel!
    @IBOutlet weak var emptyDataDescription: UILabel!
    @IBOutlet weak var emptyDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFavoritesView = self.tabBarController?.selectedIndex == 1
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.prefersLargeTitles = true
        if isFavoritesView {
            title = "Favorites"
            emptyDataTitle.text = "No Favorites"
            emptyDataDescription.text = "You haven't favorited any movies yet. Search for a movie and add it to your favorite list."
        } else {
            addSearchBar()
            emptyDataTitle.text = "No Results"
            emptyDataDescription.text = "Type the name of the movie you'd like to search on the search bar above."
        }
        tableView.accessibilityIdentifier = "table--moviesTableView"
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func loadFavoriteMovies() {
        guard let favorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [[String : Any]] else {
            return
        }
        self.movies.removeAll()
        for movieInfo in favorites {
            let movie = Movie(movieInfo: movieInfo)
            self.movies.append(movie)
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *), !isFavoritesView {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        if isFavoritesView {
            loadFavoriteMovies()
        } else {
            navigationItem.searchController?.isActive = false
            self.tableView.reloadData()
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func addSearchBar() {
        self.definesPresentationContext = true
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        search.searchBar.accessibilityIdentifier = "search--movies"
        search.definesPresentationContext = true
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
            self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
            tableView.tableHeaderView = nil
        } else {
            tableView.tableHeaderView = search.searchBar
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchForMovieWith(searchTerm: String) {
        searchCount += 1
        MovieUtility.shared.fetchMoviesFor(searchTerm: searchTerm) {[weak self] (movies, errorMessage) in
            self?.completedCount += 1
            if let error = errorMessage {
                self?.showErrorAlertWith(errorMessage: error)
            }
            if let theMovies = movies, self?.searchCount == self?.completedCount {
                self?.movies = theMovies
                self?.tableView.reloadData()
            }
        }
    }

}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyDataView.isHidden = movies.count > 0
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.directorLabel.text = "Director: \(movie.director ?? "Unknown")"
        cell.yearLabel.text = "Year: \(movie.year)"
        cell.introLabel.text = movie.briefInfo
        let currentIndexPath = indexPath
        cell.posterImageView.image = #imageLiteral(resourceName: "PosterPlaceholder")
        cell.favoriteView.isHidden = true
        if let favorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [[String : Any]] {
            cell.favoriteView.isHidden = !favorites.contains(where: { (movieInfo) -> Bool in
                return movie.id == movieInfo["trackId"] as? Int
            })
        }
        
        
        MovieUtility.shared.getPosterImageFor(movie: movie) { (image) in
            if tableView.indexPathsForVisibleRows?.contains(currentIndexPath) == true {
                cell.posterImageView.image = image
            }
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForMovieWith(searchTerm: searchText)
    }
}


extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetail") as? MovieDetailViewController {
            movieDetailVC.movie = movie
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}
