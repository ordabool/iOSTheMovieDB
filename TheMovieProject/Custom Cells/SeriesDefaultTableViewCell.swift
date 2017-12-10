//
//  SeriesDefaultTableViewCell.swift
//  TheMovieProject
//
//  Created by Admin on 05/12/2017.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SeriesDefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var seriesImageView: UIImageView!
    @IBOutlet weak var seriesTitle: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
