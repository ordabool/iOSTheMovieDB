//
//  FeaturedTableViewCell.swift
//  TheMovieProject
//
//  Created by Or Dabool on 1411//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var customViewCorners: UIView!
    @IBOutlet weak var customViewShadows: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var firsimage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var mediaDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
