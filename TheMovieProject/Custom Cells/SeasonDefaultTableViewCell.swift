//
//  SeasonDefaultTableViewCell.swift
//  TheMovieProject
//
//  Created by Admin on 06/12/2017.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SeasonDefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var seriesNameLabel: UILabel!
    @IBOutlet weak var seasonNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
