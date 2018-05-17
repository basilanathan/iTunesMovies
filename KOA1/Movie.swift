//
//  Movie.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var title: String?
    var director: String?
    var year: Int = 0
    var releaseDate: Date?
    var briefInfo: String?
    var posterURL: URL?
    var largePosterURL: URL?
    var genre: String?
    var longInfo: String?
    var id: Int
    var movieInfo: [String : Any]
    
    init(movieInfo: [String : Any]) {
        self.movieInfo = movieInfo
        director = movieInfo["artistName"] as? String
        title = movieInfo["trackName"] as? String
        if let releaseDateString = movieInfo["releaseDate"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            releaseDate = formatter.date(from: releaseDateString)
            let calendar = Calendar.current
            if let theDate = releaseDate {
                year = calendar.component(.year, from: theDate)
            }
        }
        briefInfo = movieInfo["shortDescription"] as? String
        if let artwork100 = movieInfo["artworkUrl100"] as? String {
            let largeArtwork = artwork100.replacingOccurrences(of: "100x100bb", with: "200x200bb")
            largePosterURL = URL(string: largeArtwork)
            posterURL = URL(string: artwork100)
        }
        genre = movieInfo["primaryGenreName"] as? String
        longInfo = movieInfo["longDescription"] as? String
        id = movieInfo["trackId"] as? Int ?? -1
    }

}
