//
//  MovieCell.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var favoriteView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = #imageLiteral(resourceName: "PosterPlaceholder")
    }
    
}
