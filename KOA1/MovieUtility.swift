//
//  MovieUtility.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class MovieUtility: NSObject {
    
    static let shared = MovieUtility()
    typealias MoviesResultCompletion = (_ movies: [Movie]?, _ errorMessage: String?) -> Void
    typealias MoviePosterDownloadCompletion = (_ poster: UIImage) -> Void
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    let cache = NSCache<NSString, UIImage>()

    
    func fetchMoviesFor(searchTerm: String, completion: @escaping MoviesResultCompletion) {
        dataTask?.cancel()
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=movie") else {
            completion(nil, "Something went wrong. Please contact the developer")
            return
        }
        dataTask = session.dataTask(with: url) {[weak self] data, response, error  in
            defer { self?.dataTask = nil }
            if let error = error {
                if error.localizedDescription == "cancelled" {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    return
                }
                let errorMessage = "Movie search error: " + error.localizedDescription
                DispatchQueue.main.async {
                    completion(nil, errorMessage)
                }
            } else if let theData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: theData, options: .mutableContainers)
                    if let results = (dataDictionary as? [String : Any])?["results"] as? [[String : Any]] {
                        var movies = [Movie]()
                        for movieInfo in results {
                            let movie = Movie(movieInfo: movieInfo)
                            movies.append(movie)
                        }
                        DispatchQueue.main.async {
                            completion(movies, nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(nil, "Could not search any movies for the search term \(searchTerm). Please try again later.")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, "JSON Serialization Error: " + error.localizedDescription)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(nil, "Could not search any movies for the search term \(searchTerm). Please try again later.")
                }
            }
        }
        self.dataTask?.resume()
    }
    
    func getPosterImageFor(movie: Movie, completion: @escaping MoviePosterDownloadCompletion) {
        guard let posterURL = movie.posterURL else {
            completion(#imageLiteral(resourceName: "PosterPlaceholder"))
            return
        }
        getPosterImageForURL(posterURL: posterURL, completion: completion)
    }
    
    func getLargePosterImageFor(movie: Movie, completion: @escaping MoviePosterDownloadCompletion) {
        guard let posterURL = movie.largePosterURL else {
            completion(#imageLiteral(resourceName: "PosterPlaceholder"))
            return
        }
        getPosterImageForURL(posterURL: posterURL, completion: completion)
    }
    
    private func getPosterImageForURL(posterURL: URL, completion: @escaping MoviePosterDownloadCompletion) {
        if let cachedImage = cache.object(forKey: posterURL.absoluteString as NSString) {
            completion(cachedImage)
        }
        else {
            // Download the image
            let downloadTask = session.downloadTask(with: posterURL) {[weak self] (imageURL, response, error) in
                if let imageFileURL = imageURL {
                    if let imageData = try? Data(contentsOf: imageFileURL) {
                        if let image = UIImage(data: imageData) {
                            self?.cache.setObject(image, forKey: posterURL.absoluteString as NSString)
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(#imageLiteral(resourceName: "PosterPlaceholder"))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(#imageLiteral(resourceName: "PosterPlaceholder"))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(#imageLiteral(resourceName: "PosterPlaceholder"))
                    }
                }
            }
            
            downloadTask.resume()
        }
    }
    
}
